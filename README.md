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
I've chosen the quickest way to implement mark as seen feature using UserDefaults, but after thinking about it, I'm pretty sure it should also be done with BeSocial API so the author can see the list of users who have seen the story.
### Other
- Use smart async image framework instead of native `AsyncImage` component (eg: [Nuke](https://github.com/kean/Nuke))
- Add <ins>Haptics Feedback while navigating through stories.
    
