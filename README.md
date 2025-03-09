# BeSocial: Technical Test for BeReal

> [!NOTE]  
> I've continued to have fun with this project here: [this branch](https://github.com/appcraftconsulting/besocial_technical_test/tree/extra/bug_fixes_and_improvements)!
> 
Thanks for taking the time to review my work! 😀

As requested, here is the source code of a "Instagram Stories-like" feature nested in a sample app.
I've chosen to modularize my code into 4 packages:
- 📦 **BeSocial > StoriesFeature** : Contains the stories feature, depends on sub-packages, imported by main app.
- 📦 **BeSocialDataProvider** : This package contains all the "BeSocial API" related things. It also embeds its own DTO models. In this package, I've added `FakeEndpoint` simulating server, based on json file stored on device.
- 📦 **BeSocialEntity** : Contains all the models used by the main app, esp. in the UI.
- 📦 **BeSocialRepositories** : This framework add feature implementations using data provider functions and local adapters to parse DTOs to common entities.

I've chosen this architecture because it's one I've often worked with, pretty simple to use, ease to read, and ready to be tested!

By splitting code into functional areas, we ensure keeping small files, with separation of concerns.

## How I spent my time?
Actually things gone bad when I started the project:
After ~30 minutes writing code, I've noticed packages were not added in the project directory, so I decided to move them back to it from Finder 🤦🏻‍♂️

This caused to broke the entire project, even after cleaning & deleting derived data, Xcode still refused to compile the project.
I had to select manually all compile sources & bundle resources to restore it.
- 2h30+ on architecture
- 1h00 on UI (very frustrating because SwiftUI is actually something I love working with)
- 30mn on debugging my packages issue

## What is missing?
### Error management
- Catch native error in Gateway to throws BeSocialError (from BeSocialEntity) instead.
- Display native or custom alert if BeSocialError is catched from viewmodel.
### Like/Unlike feature
- Add new `LikeStoryEndpoint (new)` to `BeSocialDataProvider` + corresponding fetcher
- Use common `LocalDatabase (new)` instance stored in `DataProvider` class to feed fake endpoints
- `likeStory(withId id: String) async throws -> Story` would return updated story
### Stories Store
- Fetchers should actually be embedded in StoriesStore, to keep stories synced across different viewModels
- -> That would enable the pagination from full scren stories (when you reach the last fetched story in full screen, you could fetch next batch from full screen view)

## What could be improved?
### Gestures
- Replacing current broken drag gestures by tabview or `ScrollView` + `SrollViewBehavior` to add paging effect
- Add tap gesture to both edges of the story view to navigate between story pages.
### Mark as Seen feature
I've chosen the quickest way to implement "Mark as Seen" feature using `UserDefaults`, but after thinking about it, I'm pretty sure it should also be done with _BeSocial API_ so the author can see the list of users who have seen the story.
### Other
- Use smart async image framework instead of native `AsyncImage` component (eg: [Nuke](https://github.com/kean/Nuke))
- Add Haptics Feedback while navigating through stories.
- Improve accessibility by adding custom labels & groups
- Add button and interactive gesture to close stories
