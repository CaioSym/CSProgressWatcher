//
//  CSProgressWatcherSpec.swift
//  CSProgressWatcher
//
//  Created by Caio Freitas Sym on 4/8/17.
//  Copyright © 2017 Caio Sym. All rights reserved.
//

import Quick
import Nimble
import CSProgressWatcher



class MockCSProgressWatcherDelegate: CSProgressWatcherDelegate {
    var lastCompletedUnitCountUpdate: UnitCountUpdate?
    var lastTotalUnitCountUpdate: UnitCountUpdate?
    
    func progress(_ progress:Progress, didUpdateCompletedUnitCountFrom old: Int64, to new: Int64) {
        lastCompletedUnitCountUpdate = UnitCountUpdate(progress: progress, old: old, new: new)
    }
    
    func progress(_ progress:Progress, didUpdateTotalUnitCountFrom old: Int64, to new: Int64) {
        lastTotalUnitCountUpdate = UnitCountUpdate(progress: progress, old: old, new: new)
    }
    
    struct UnitCountUpdate: Equatable {
        let progress: Progress
        let old: Int64
        let new: Int64
        
        public static func ==(lhs: MockCSProgressWatcherDelegate.UnitCountUpdate, rhs: MockCSProgressWatcherDelegate.UnitCountUpdate) -> Bool {
            return lhs.progress == rhs.progress &&
                lhs.old == rhs.old &&
                lhs.new == rhs.new
        }
    }
}


class CSProgressWatcherSpec: QuickSpec {
    override func spec() {
        describe("A CSProgressWatcher") {
            var progress: Progress!
            var watcher: CSProgressWatcher!
            var delegate: MockCSProgressWatcherDelegate!
            
            beforeEach {
                delegate = MockCSProgressWatcherDelegate()
            }
            
            context("Watching a simple Progress") {
                beforeEach {
                    progress = Progress(totalUnitCount: 100)
                    watcher = CSProgressWatcher(progress: progress)
                    watcher.delegate = delegate
                }
                
                it("Should pick up updates to completed count") {
                    progress.completedUnitCount = 5
                    let expected = MockCSProgressWatcherDelegate
                        .UnitCountUpdate(progress: progress, old: 0, new: 5)
                    expect(delegate.lastCompletedUnitCountUpdate)
                        .toEventually(equal(expected))
                }
                
                it("Should pick up updates to total count") {
                    progress.totalUnitCount = 180
                    let expected = MockCSProgressWatcherDelegate
                        .UnitCountUpdate(progress: progress, old: 100, new: 180)
                    expect(delegate.lastTotalUnitCountUpdate)
                        .toEventually(equal(expected))
                }
                
                it("Should not pick up same value updates") {
                    progress.totalUnitCount = 100
                    expect(delegate.lastTotalUnitCountUpdate)
                        .toEventually(beNil())
                }
            }
            
            context("Watching a Progress with children") {
                var childProgress1: Progress!
                var childProgress2: Progress!
                
                beforeEach {
                    progress = Progress(totalUnitCount: 100)
                    childProgress1 = Progress(totalUnitCount: 100, parent: progress, pendingUnitCount: 20)
                    childProgress2 = Progress(totalUnitCount: 100, parent: progress, pendingUnitCount: 50)
                    watcher = CSProgressWatcher(progress: progress)
                    watcher.delegate = delegate
                }
                
                it("Should not pick up updates while the child progresses dont complete") {
                    childProgress1.completedUnitCount = 50
                    expect(delegate.lastCompletedUnitCountUpdate)
                        .toEventually(beNil())
                    childProgress2.completedUnitCount = 50
                    expect(delegate.lastCompletedUnitCountUpdate)
                        .toEventually(beNil())
                }
                
                it("Should pick up updates as the child progresses complete") {
                    childProgress1.completedUnitCount = 100
                    var expected = MockCSProgressWatcherDelegate
                        .UnitCountUpdate(progress: progress, old: 0, new: 20)
                    expect(delegate.lastCompletedUnitCountUpdate)
                        .toEventually(equal(expected))
                    childProgress2.completedUnitCount = 100
                    expected = MockCSProgressWatcherDelegate
                        .UnitCountUpdate(progress: progress, old: 20, new: 70)
                    expect(delegate.lastCompletedUnitCountUpdate)
                        .toEventually(equal(expected))
                }
            }
        }
    }
}
