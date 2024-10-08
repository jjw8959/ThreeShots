//
//  DataManager.swift
//  ThreePicDiary
//
//  Created by woong on 8/9/24.
//

import UIKit
import CoreData

final class DataManager {
    
    static let shared = DataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    let diaryEntity = "Diarys"
    
    var offset = 0
    
    func saveData(userDiary: Diary) {
        let diarys = Diarys(context: context)
        diarys.date = userDiary.date
        diarys.content = userDiary.content
        diarys.year = userDiary.year
        diarys.month = userDiary.month
        
        saveImage(date: userDiary.date, image: userDiary.firstImage, name: "firstImage")
        saveImage(date: userDiary.date, image: userDiary.secondImage, name: "secondImage")
        saveImage(date: userDiary.date, image: userDiary.thirdImage, name: "thirdImage")
        diarys.firstImage = "\(userDiary.date)_firstImage.jpeg"
        diarys.secondImage = "\(userDiary.date)_secondImage.jpeg"
        diarys.thirdImage = "\(userDiary.date)_thirdImage.jpeg"
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print(error.localizedDescription)
        }
    }
    
    func loadData(date: String) -> Diary? {
        let request = NSFetchRequest<NSManagedObject>(entityName: diaryEntity)
        request.predicate = NSPredicate(format: "date = %@", date)
        
        do {
            let data = try context.fetch(request)
            
            guard let result = data.first else {
                return Diary(date: "", year: "", month: "", content: "아직 일기가 없어요...", firstImage: nil, secondImage: nil, thirdImage: nil)
            }
            
            let temp = Diary(date: result.value(forKey: "date") as! String,
                             year: result.value(forKey: "year") as! String,
                             month: result.value(forKey: "month") as! String,
                             content: result.value(forKey: "content") as? String,
                             firstImage: result.value(forKey: "firstImage") as? UIImage,
                             secondImage: result.value(forKey: "secondImage") as? UIImage,
                             thirdImage: result.value(forKey: "thirdImage") as? UIImage)
            return temp
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func loadMonthData(year: String, month: String) -> [Diary]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        let yearPredicate = NSPredicate(format: "year = %@", year)
        let monthPredicate = NSPredicate(format: "month = %@", month)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
        request.predicate = compoundPredicate
        
        do {
            let data = try context.fetch(request)
            var results: [Diary] = []
            
            for result in data as! [NSManagedObject] {
                let date = result.value(forKey: "date") as! String
                let year = result.value(forKey: "year") as! String
                let month = result.value(forKey: "month") as! String
                let content = result.value(forKey: "content") as! String
                let firstImagePath = result.value(forKey: "firstImage") as! String
                let secondImagePath = result.value(forKey: "secondImage") as! String
                let thirdImagePath = result.value(forKey: "thirdImage") as! String
                
                let firstImage = loadImage(path: firstImagePath)
                let secondImage = loadImage(path: secondImagePath)
                let thirdImage = loadImage(path: thirdImagePath)
                results.append(Diary(date: date, year: year, month: month, content: content, firstImage: firstImage, secondImage: secondImage, thirdImage: thirdImage))
            }
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func loadDailyData() -> [Diary]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 15
        request.fetchOffset = offset
        
        
        do {
            let datas = try context.fetch(request)
            var results: [Diary] = []
            
            for data in datas as! [NSManagedObject] {
                let date = data.value(forKey: "date") as! String
                let year = data.value(forKey: "year") as! String
                let month = data.value(forKey: "month") as! String
                let content = data.value(forKey: "content") as! String
                let firstImagePath = data.value(forKey: "firstImage") as! String
                let secondImagePath = data.value(forKey: "secondImage") as! String
                let thirdImagePath = data.value(forKey: "thirdImage") as! String
                
                let firstImage = loadImage(path: firstImagePath)
                let secondImage = loadImage(path: secondImagePath)
                let thirdImage = loadImage(path: thirdImagePath)
                results.append(Diary(date: date, year: year, month: month, content: content, firstImage: firstImage, secondImage: secondImage, thirdImage: thirdImage))
            }
            
            offset += results.count
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func updateData(userDiary: Diary) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        request.predicate = NSPredicate(format: "date = %@", userDiary.date)
        
        do {
            let data = try context.fetch(request)
            if let existingDiary = data.first as? NSManagedObject {
                existingDiary.setValue(userDiary.date, forKey: "date")
                existingDiary.setValue(userDiary.content, forKey: "content")
                existingDiary.setValue(userDiary.year, forKey: "year")
                existingDiary.setValue(userDiary.month, forKey: "month")
                
                saveImage(date: userDiary.date, image: userDiary.firstImage, name: "firstImage")
                existingDiary.setValue("\(userDiary.date)_firstImage.jpeg", forKey: "firstImage")
                saveImage(date: userDiary.date, image: userDiary.secondImage, name: "secondImage")
                existingDiary.setValue("\(userDiary.date)_secondImage.jpeg", forKey: "secondImage")
                saveImage(date: userDiary.date, image: userDiary.thirdImage, name: "thirdImage")
                existingDiary.setValue("\(userDiary.date)_thirdImage.jpeg", forKey: "thirdImage")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(diary: Diary) {
        let date = diary.date
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        request.predicate = NSPredicate(format: "date = %@", date)
        
        do {
            let data = try context.fetch(request)
            if let targetDiary = data.first as? NSManagedObject {
                if let firstImage = targetDiary.value(forKey: "firstImage") {
                    deleteImage(path: firstImage as! String)
                }
                if let firstImage = targetDiary.value(forKey: "secondImage") {
                    deleteImage(path: firstImage as! String)
                }
                if let firstImage = targetDiary.value(forKey: "thirdImage") {
                    deleteImage(path: firstImage as! String)
                }
            }
            for temp in data as! [NSManagedObject] {
                context.delete(temp)
                print("삭제 실행됨")
            }
            try context.save()
            print("삭제후 저장 실행됨")
        } catch {
            print("삭제 실패")
        }
    }
  
    func resetCoreData() {
        let persistentContainer = appDelegate.persistentContainer
        let coordinator = persistentContainer.persistentStoreCoordinator
        
        for store in coordinator.persistentStores {
            if let storeURL = store.url {
                do {
                    try coordinator.destroyPersistentStore(at: storeURL, ofType: store.type, options: nil)
                } catch {
                    print("Failed to destroy persistent store: \(error)")
                }
            }
        }
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
//    MARK: 이미지 저장 관련
    
    private func getAppDir() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveImage(date: String, image: UIImage?, name: String) {
        if let image = image {
            let path = "\(date)_\(name).jpeg"
            let imageURL = getAppDir().appending(path: path)
            if let image = image.jpegData(compressionQuality: 0.5) {
                do {
                    try image.write(to: imageURL)
                } catch {
                    print("이미지 저장 실패")
                }
            }
        } else {
            print("image is nil")
        }
    }
    
    private func loadImage(path: String) -> UIImage? {
        let path = path
        let imageURL = getAppDir().appending(path: path)
        guard let image = try? Data(contentsOf: imageURL) else { return nil }
        return UIImage(data: image)
    }
    
    private func deleteImage(path: String) {
        let imageURL = getAppDir().appending(path: path)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
