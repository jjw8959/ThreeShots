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
        let newDiary = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context)
        newDiary.setValue(date, forKey: "date")
        newDiary.setValue(content, forKey: "content")
        
        if let firstImagePath = saveImageToDisk(image: firstImage, imageName: "firstImage", date: date) {
            newDiary.setValue(firstImagePath, forKey: "firstImage")
        }
        
        if let secondImagePath = saveImageToDisk(image: secondImage, imageName: "secondImage", date: date) {
            newDiary.setValue(secondImagePath, forKey: "secondImage")
        }
        
        if let thirdImagePath = saveImageToDisk(image: thirdImage, imageName: "thirdImage", date: date) {
            newDiary.setValue(thirdImagePath, forKey: "thirdImage")
        }
        
        do {
            try context.save()
            print("저장 성공")
        } catch {
            print("저장 실패")
        }
    }
    
    // 이게 최종 메서드, 위의 load는 지우기
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
    
    func updateData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        request.predicate = NSPredicate(format: "content", "아 놀구 십따")
        
        do {
            let data = try context.fetch(request)
            if let result = data.first as? NSManagedObject {
                let contents = result.value(forKey: "content") as? String ?? ""
            }
            
            try context.save()
        } catch {
            print("update Failed")
        }
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
    func saveImageToDisk(image: UIImage, imageName name: String, date: String) -> String? {
        let fileURL = getDocumentDir().appendingPathComponent("\(date)_\(name).jpg")
        if let data = image.jpegData(compressionQuality: 0.5) {
            do {
                try data.write(to: fileURL)
//                print("Image saved to: \(fileURL.path)")  // 디버깅용 출력
                return fileURL.path
            } catch {
                print("Failed to write image data to disk: \(error)")
            }
        }
        return nil
    }
    
    func loadImageFromDisk(path: String) -> UIImage? {
        print("Loading image from: \(path)")
        if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
