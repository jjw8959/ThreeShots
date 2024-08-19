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
    
    //    MARK: create
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
//        if let entity = NSEntityDescription.entity(forEntityName: diaryEntity, in: context) {
//            let managedObject = NSManagedObject(entity: entity, insertInto: context)
//            managedObject.setValue(userDiary.date, forKey: "date")
//            managedObject.setValue(userDiary.content, forKey: "content")
//            
//            saveImage(date: userDiary.date, image: userDiary.firstImage, name: "firstImage")
//            managedObject.setValue("\(userDiary.date)_firstImage.jpeg", forKey: "firstImage")
//            saveImage(date: userDiary.date, image: userDiary.secondImage, name: "secondImage")
//            managedObject.setValue("\(userDiary.date)_secondImage.jpeg", forKey: "secondImage")
//            saveImage(date: userDiary.date, image: userDiary.thirdImage, name: "thirdImage")
//            managedObject.setValue("\(userDiary.date)_thirdImage.jpeg", forKey: "thirdImage")
//            
//            do {
//                try context.save()
//            } catch {
//                // TODO: 에러핸들링 적용해보기
//                print("saveContext 실패\(error.localizedDescription)")
//            }
//        }
    }
    
    //    TODO: read
    func loadData(date: String) -> Diary {
        let request = NSFetchRequest<NSManagedObject>(entityName: diaryEntity)
        request.predicate = NSPredicate(format: "date = %@", date)
        
//        do {
//            let data = try? context.fetch(request)
//        } catch {
//            print(error.localizedDescription)
//        }
        let data = try? context.fetch(request)
        guard let result = data?.first as? NSManagedObject else {
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
    }
    
    func loadMonthData(year: String, month: String) -> [Diary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        
        let yearPredicate = NSPredicate(format: "year = %@", year)
        let monthPredicate = NSPredicate(format: "month = %@", month)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
        
        request.predicate = compoundPredicate
        let data = try? context.fetch(request)
        
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
    }
    
    //    TODO: update
    
    //    TODO: delete
    func deleteData(diary: Diary) {
        let date = diary.date
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: diaryEntity)
        request.predicate = NSPredicate(format: "date = %@", date)
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                print("삭제 실행됨")
            }
            try context.save()
            print("삭제후 저장 실행됨")
        } catch {
            print("삭제 실패")
        }
    }
    
    
//    func loadData(date: String) -> (date: String, content: String, firstImage: UIImage, secondImage: UIImage, thirdImage: UIImage) {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
//        request.predicate = NSPredicate(format: "date = %@", date)
//        
//        var data: [NSfetchrequest]?
//        
//    }
    //    MARK: 데이터 리셋
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
    
//    MARK: 이미지 저장 관련
    
    func getAppDir() -> URL {
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
                    // TODO: 에러핸들링 적용해보기
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
        guard let image = try? Data(contentsOf: imageURL) else { return UIImage(named: "gray") }
        return UIImage(data: image)
    }
}
