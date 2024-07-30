//
//  CoredataManager.swift
//  ThreeShots
//
//  Created by woong on 7/26/24.
//

import UIKit
import CoreData

class CoredataManager {
    
    static let shared = CoredataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // 이미지 저장경로 url로 따오기
    func saveData(date: String, content: String, firstImage: UIImage, secondImage: UIImage, thirdImage: UIImage) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        request.predicate = NSPredicate(format: "date = %@", date)
        
        do {
            let data = try context.fetch(request)
            if let existingDiary = data.first as? NSManagedObject {
                // 기존 데이터가 있으면 업데이트
                existingDiary.setValue(content, forKey: "content")
                
                saveImageToDisk(image: firstImage, imageName: "firstImage", date: date)
                let firstImagePath = date + "_" + "firstImage.jpg"
                existingDiary.setValue(firstImagePath, forKey: "firstImage")
                
                saveImageToDisk(image: secondImage, imageName: "secondImage", date: date)
                let secondImagePath = date + "_" + "secondImage.jpg"
                existingDiary.setValue(secondImagePath, forKey: "secondImage")
                
                saveImageToDisk(image: thirdImage, imageName: "thirdImage", date: date)
                let thirdImagePath = date + "_" + "thirdImage.jpg"
                existingDiary.setValue(thirdImagePath, forKey: "thirdImage")
                
                let month = date.substring(from: 5, to: 6)
                existingDiary.setValue(month, forKey: "month")
                
                let year = date.substring(from: 0, to: 3)
                existingDiary.setValue(year, forKey: "year")
                print(year)
                
            } else {
                // 기존 데이터가 없으면 새로 추가
                let newDiary = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context)
                newDiary.setValue(date, forKey: "date")
                newDiary.setValue(content, forKey: "content")
                print("saveData", content)
                
                saveImageToDisk(image: firstImage, imageName: "firstImage", date: date)
                let firstImagePath = date + "_" + "firstImage.jpg"
                newDiary.setValue(firstImagePath, forKey: "firstImage")
                
                saveImageToDisk(image: secondImage, imageName: "secondImage", date: date)
                let secondImagePath = date + "_" + "secondImage.jpg"
                newDiary.setValue(secondImagePath, forKey: "secondImage")
                
                saveImageToDisk(image: thirdImage, imageName: "thirdImage", date: date)
                let thirdImagePath = date + "_" + "thirdImage.jpg"
                newDiary.setValue(thirdImagePath, forKey: "thirdImage")
                
                let month = date.substring(from: 5, to: 6)
                newDiary.setValue(month, forKey: "month")
                
                let year = date.substring(from: 0, to: 3)
                newDiary.setValue(year, forKey: "year")
                
            }
            
            try context.save()
            print("저장 성공")
        } catch {
            print("저장 실패")
        }
    }
    
    func loadData(date: String) -> (date: String,
                                    contents: String,
                                    firstImage: UIImage?,
                                    secondImage: UIImage?,
                                    thirdImage: UIImage?
    ) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        request.predicate = NSPredicate(format: "date = %@", date)
        
        var data: [NSFetchRequestResult]?
        
        do {
            data = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return ("", "아직 일기가 없어요...", nil, nil, nil)
        }
        guard let result = data?.first as? NSManagedObject else { return ("", "아직 일기가 없어요...", nil, nil, nil) }
        
        let contents = result.value(forKey: "content") as? String ?? ""
        let firstImagePath = result.value(forKey: "firstImage") as? String ?? ""
        let secondImagePath = result.value(forKey: "secondImage") as? String ?? ""
        let thirdImagePath = result.value(forKey: "thirdImage") as? String ?? ""
        let date = result.value(forKey: "date") as? String ?? ""
        
        let firstImage = loadImageFromDisk(path: firstImagePath)
        let secondImage = loadImageFromDisk(path: secondImagePath)
        let thirdImage = loadImageFromDisk(path: thirdImagePath)
        
        return (date, contents, firstImage, secondImage, thirdImage)
    }
    
    func loadMonthData(year: String, month: String) -> [(dateString: String, texts: String, firstImage: UIImage?, secondImage: UIImage?, thirdImage: UIImage?)] {
        print("실행됨")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let monthPredicate = NSPredicate(format: "month == %@", month)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
        
        request.predicate = predicate
        
        var data: [NSFetchRequestResult]?
        
        do {
            data = try context.fetch(request)
        } catch {
            print("에러로 실행됨")
            print(error.localizedDescription)
            return []
        }
        var results: [(dateString: String, texts: String, firstImage: UIImage?, secondImage: UIImage?, thirdImage: UIImage?)] = []
        
        for result in data as! [NSManagedObject] {
            let texts = result.value(forKey: "content") as? String ?? ""
            let firstImagePath = result.value(forKey: "firstImage") as? String ?? ""
            let secondImagePath = result.value(forKey: "secondImage") as? String ?? ""
            let thirdImagePath = result.value(forKey: "thirdImage") as? String ?? ""
            let dateString = result.value(forKey: "date") as? String ?? ""
            
            let firstImage = loadImageFromDisk(path: firstImagePath)
            let secondImage = loadImageFromDisk(path: secondImagePath)
            let thirdImage = loadImageFromDisk(path: thirdImagePath)
            
            results.append((dateString, texts, firstImage, secondImage, thirdImage))
        }
        return results
    }
    
    func deleteData(date: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
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
            print("delete Failed")
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
    
    // MARK: 이미지 저장을 위한 fileManager 파트
    
    // 앱의 document 디렉토리를 가져옴.
    func getDocumentDir() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    // 해당위치에 이미지를 저장함.
    func saveImageToDisk(image: UIImage, imageName name: String, date: String) {
        let fileURL = getDocumentDir().appendingPathComponent("\(date)_\(name).jpg")
        if let data = image.jpegData(compressionQuality: 0.5) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("Failed to write image data to disk: \(error)")
            }
        }
    }
    
    func loadImageFromDisk(path: String) -> UIImage? {
        let fileURL = getDocumentDir().appendingPathComponent(path)
        if let imageData = try? Data(contentsOf:  fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
