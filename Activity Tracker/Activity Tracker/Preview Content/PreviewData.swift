//
//  PreviewData.swift
//  DayTracker
//
//  Created by Luu Van on 7/9/21.
//

import CoreData
import UIKit

struct PreviewData {
  static let folderNames = [
    "anniversary",
    "liability",
    "qualification",
    "constituency",
    "representative"
  ]

  static let tagNames = ["Don’t be nervous!",
                                 "Good morning!",
                                 "He threw up all over me!",
                                 "What a big dog that is!",
                                 "Look at me right now I'm about to fall!",
                                 "What a big house you have!",
                                 "You're so basic!",
                                 "What a big eater he is!",
                                 "Don't go there!",
                                 "identification",
                                 "investigation",
                                 "preoccupation",
                                 "disability",
                                 "enthusiasm",
                                 "accumulation",
                                 "multimedia",
                                 "hospitality",
                                 "superintendent",
                                 "environmental",
                                 "ideology",
                                 "vegetarian",
                                 "constituency",
                                 "discrimination",
                                 "responsibility",
                                 "beneficiary",
                                 "cooperative",
                                 "qualification",
                                 "extraterrestrial",
                                 "homosexual"]

  static let activityNotes = [
    "anniversary",
    "liability",
    "qualification",
    "constituency",
    "representative",
    "The knives were out and she was sharpening hers.",
    "He is no James Bond; his name is Roger Moore.",
    "My parents wanted me to become a doctor.",
    "She used her own hair in the soup to give it more flavor.",
    "Sometimes it is better to just walk away from things and go back to them later when you’re in a better frame of mind.",
    "Can I get you something to drink?",
    "She saw the brake lights, but not in time.",
    "People who insist on picking their teeth with their elbows are so annoying!",
    "Pat ordered a ghost pepper pie.",
    "I liked their first two albums but changed my mind after that charity gig.",
    "Art doesn't have to be intentional."
  ]

  public static var mockTags = [Tag]()

  static func initPreviewData(with context: NSManagedObjectContext) {

    let folders = initFolder(withContext: context, folderNames: folderNames)
    mockTags = initTag(withContext: context, folders: folders, tagNames:tagNames)
    let _ = initActivities(withContext: context, tags: mockTags, notes: activityNotes)

    do {
      try context.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }

  static func initFolder(withContext context: NSManagedObjectContext, folderNames: [String]) -> [Folder] {
    return folderNames.map { name in
      let folder = Folder(context: context)
      folder.name = name
      return folder
    }
  }

  static func initTag(withContext context: NSManagedObjectContext, folders: [Folder], tagNames: [String]) -> [Tag] {
    return tagNames.map { name in
      let tag = Tag(context: context)
      tag.name = name
      tag.folder = folders.randomElement() ?? nil
      return tag
    }
  }

  static func initActivities(withContext context: NSManagedObjectContext, tags: [Tag], notes: [String?]) -> [Activity] {
    return notes.map { note in
      let activity = Activity(context: context)

      tags.multipleRandom(7).forEach { tag in
        activity.addToTags(tag)
      }

      activity.time = Date.randomBetween(start: Date().dayBefore, end: Date().dayAfter)
      activity.note = note
      return activity
    }
  }
}

extension UIColor {
  static var random: UIColor {
    return UIColor(red: .random(in: 0...1),
                   green: .random(in: 0...1),
                   blue: .random(in: 0...1),
                   alpha: 1.0)
  }
}

extension Collection {
  func multipleRandom(_ num: Int) -> [Element] {
    if count == 0 { return [] }

    return (0 ..< num).map { _ in randomElement() ?? first! }
  }
}
