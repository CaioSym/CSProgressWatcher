//
//  CSProgressWatcher.swift
//  CSProgressWatcher
//
//  Created by Caio Freitas Sym on 2/12/17.
//  Copyright © 2017 Caio Sym. All rights reserved.
//

import Foundation

///The delegate for a `CSProgressWatcher`
public protocol CSProgressWatcherDelegate: class {
    func progress(_ progress:Progress, didUpdateCompletedUnitCountFrom old: Int64, to new: Int64);
    func progress(_ progress:Progress, didUpdateTotalUnitCountFrom old: Int64, to new: Int64);
}

/// A watcher for `Progress` objects
public class CSProgressWatcher: NSObject {
    
    ///The `Progress` being watched
    public let progress: Progress
    
    ///The delegate to be notified when there are changes to the progress
    public weak var delegate: CSProgressWatcherDelegate?
    
    ///Create a `CSProgressWatcher` for the given `Progress`
    public init(progress: Progress) {
        self.progress = progress
        super.init()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - KVO
extension CSProgressWatcher {
    
    ///KeysPaths for `Progress` Objects
    fileprivate struct ProgressKeyPath {
        static let totalUnitCount = "totalUnitCount"
        static let completedUnitCount = "completedUnitCount"
    }
    
    fileprivate func addObservers() {
        progress.addObserver(self, forKeyPath: ProgressKeyPath.completedUnitCount, options: [.old, .new], context: nil)
        progress.addObserver(self, forKeyPath: ProgressKeyPath.totalUnitCount, options: [.old, .new], context: nil)
    }
    
    fileprivate func removeObservers() {
        progress.removeObserver(self, forKeyPath: ProgressKeyPath.completedUnitCount)
        progress.removeObserver(self, forKeyPath: ProgressKeyPath.totalUnitCount)
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if progress.isEqual(object){
            guard
                let old = change?[NSKeyValueChangeKey.oldKey] as? Int64,
                let new = change?[NSKeyValueChangeKey.newKey] as? Int64
                else {
                    debugPrint("\(type(of:self)) Error: failed to get values from change dictionary.")
                    return
            }
            
            if keyPath == ProgressKeyPath.completedUnitCount {
                progressDidUpdateCompletedUnitCount(from: old, to: new)
            } else if keyPath == ProgressKeyPath.totalUnitCount {
                progressDidUpdateTotalUnitCount(from: old, to: new)
            }
        }
    }
}

// MARK: - CSProgressWatcher Delegation
extension CSProgressWatcher {
    fileprivate func progressDidUpdateCompletedUnitCount(from old: Int64, to new: Int64) {
        if let delegate = delegate {
            delegate.progress(progress, didUpdateCompletedUnitCountFrom: old, to: new)
        }
    }
    
    fileprivate func progressDidUpdateTotalUnitCount(from old: Int64, to new: Int64) {
        if let delegate = delegate {
            delegate.progress(progress, didUpdateTotalUnitCountFrom: old, to: new)
        }
    }
}
