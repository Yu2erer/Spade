//
//  NTSQLiteManager.swift
//  sql
//
//  Created by ntian on 2017/5/16.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
import FMDB

class NTSQLiteManager {
    
    static let shared = NTSQLiteManager()
    // 数据库队列
    let queue: FMDatabaseQueue
    private init() {
        // 创建数据库队列
        let dbName = "dashboard.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        print("\(path)")
        queue = FMDatabaseQueue(path: path)
        createTable()
    }
}
// MARK: - dashBoard 数据操作
extension NTSQLiteManager {
    
    /// 新增或修改dashBoard 数据
    func updateDashBoard(userId: String, array: [[String: Any]]) {
        // 准备 sql
        let sql = "INSERT OR REPLACE INTO T_dashboard (id, userId, dashboard) VALUES (?, ?, ?);"
        // 执行sql
        queue.inTransaction { (db, rollback) in
            // 遍历数组 逐条插入 dashBoard 数据
            for dict in array {
            
                guard let id = dict["id"], let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                if db?.executeUpdate(sql, withArgumentsIn: ["\(id)", userId, jsonData]) == false {
                    // 回滚
                    rollback?.pointee = true
                    print("写入失败了")
                    break
                }
            }
        }
        
    }
}
// MARK: - 创建数据库及其他私有方法
extension NTSQLiteManager {
    
    func loadDashBoard(userId: String, since_id: String, offset: String) -> [[String: Any]] {
        
        var sql = "SELECT id, userId, dashboard FROM T_dashboard \n"
        sql += "WHERE userId = \(userId) \n"
        /// 首次进入的时候 sinceId 和 offset 都会为空
        // 然后下拉刷新 offset 为空 
        // 上拉刷新 sinceId 为空
        /// 下拉刷新
        if since_id != "nil" && since_id != "" {
            sql += "AND id > \(since_id) \n"
            sql += "ORDER BY id DESC LIMIT 20;"
        } else if offset != "" {
            sql += "ORDER BY id DESC LIMIT 20 OFFSET \(offset);"
        } else {
            sql += "ORDER BY id DESC LIMIT 20;"

        }
   
        print(sql)
        // 执行 sql
        let array = execRecordSet(sql: sql)
        // 遍历数组 将数组中的 dashboard 反序列化
        var result = [[String: Any]]()
        for dict in array {
            // 反序列化
            guard let jsonData = dict["dashboard"] as? Data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                continue
            }
            // 追加到 数组
            result.append(json ?? [:])
        }
        
        return result
    }
    /// 执行 一个sql 返回字典数组
    func execRecordSet(sql: String) -> [[String: Any]] {
        
        var result = [[String: Any]]()
        // 执行sql 查询数据不会修改数据 不需要开启事务
        queue.inDatabase { (db) in
            
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            // 逐行遍历结果集合
            while rs.next() {
                /// 列数
                let colCount = rs.columnCount()
                // 遍历所有列
                for col in 0..<colCount {
                    
                    /// 列名 -> Key 值 -> Value
                    guard let name = rs.columnName(for: col), let value = rs.object(forColumnName: name) else {
                        continue
                    }
                    /// 追加结果
                    result.append([name: value])
                }
            }
        }
        return result
    }
    /// 创表
    func createTable() {
        guard let path = Bundle.main.path(forResource: "dashboard.sql", ofType: nil), let sql = try? String(contentsOfFile: path)
        else {
            return
        }
        queue.inDatabase { (db) in
            if db?.executeStatements(sql) == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
        print("over")
    }
}
