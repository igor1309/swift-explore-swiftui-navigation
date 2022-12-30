# swift-explore-navigation

Exploring state-driven navigation in SwiftUI: API and navigation modeling.

UI inspired by СберМаркет app.

## References

### Searchable Map with SwiftUI

- [Episode #156: Searchable SwiftUI: Part 1](https://www.pointfree.co/episodes/ep156-searchable-swiftui-part-1)

    Episode #156 • Aug 9, 2021 • Free Episode
    Let’s develop a new application from scratch to explore SwiftUI’s new .searchable API. We’ll use MapKit to search for points of interest, and we will control this complex dependency so that our application can be fully testable.

- [Episode #157: Searchable SwiftUI: Part 2](https://www.pointfree.co/collections/wwdc/wwdc-2021/ep157-searchable-swiftui-part-2#t85)

    Episode #157 • Aug 16, 2021 • Free Episode
    We finish our search-based application by adding and controlling another MapKit API, integrating it into our application so we can annotate a map with search results, and then we’ll go the extra mile and write tests for the entire thing!

- [Searchable modifier in SwiftUI: A UISearchController and UISearchBar equivalent | Sarunw](https://sarunw.com/posts/searchable-in-swiftui/)

- [Craft search experiences in SwiftUI - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10176/)

## Add new address to profile using map

### Core functionality/components/modules

#### Map Domain

Each implementation should be adapted to speak MapDomain language.

#### Async

Every search API is async, could be async/await or Combine publisher.

#### Infra implementation

Each service could have different providers, for example map rendering could be implemented using Apple’s, Google’s, or Yandex’ API; first implementation would use Apple’s API.

#### Map Rendering

- Two-way communication via binding of (coordinate) region
- Responsible for map rendering and pan-zoom interactions

#### Address for coordinate search

- (region center) -> Address?

#### Search completions

- (String/Query) -> [Completions]

#### Search results

- (String/Query) -> [(Address, coordinate)]

### AddressMapSearch
Using map and search bar to search for address

#### Q
Should it be split to 2 components: one responsible for map interactions and search for address using coordinates of map center; another for search field (looks like a view modifier functionality).
Splitting would simplify tests. Composition - a thing to think about…

### State
There is a way to think about the state of this component as in the mentoring session with a payment form:

enum ViewState {
    case map(CoordinateRegion)
    case search(searchText: String, suggestions: Suggestions)
}

And this enum clearly shows that this could be split into two components - map and search.

The problem: map. When we search - and state is /ViewState.search what is the map state? The is a binding to map state used in the child component so we need to provide a value. Reset to initial? But what if the user was interacting with the map and changed the region - how relevant reverting to the initial would be? If we get search results and complete with search result selection with address and region - ok, but if we cancel search what region should map use? Initial? Or some pre-search? - meaning we need to store this pre-search value and pass is as constant binding - but just mean that it’s not a separate state case, so enum is a wrong way to model view state here.

So, it does not look like mutually exclusive, let’s go with fields - could wrap in a struct:

Wrapping fields in a struct does make a lot of sense:
    - better (thorough) unit and snapshot testing

#### State fields:

- coordinate region
- enum SearchState (or optional struct)
    - case none
    - case search with associated struct/fields:
        - searchText
        - search suggestions:
            - search completions, or
            - search results (addresses with corresponding coordinate region)
- Address state (as in code now: none, searching, value)

Plus a number of computed properties to facilitate view rendering(?)

Strictly speaking, coordinate region and search field (with suggestions) are mutually exclusive states (no, that’s not correct!), or rather exclusive interaction ways - we either zoom and pan the map or use search field and suggestions (completions and search results), not both.

### Tests

#### Init should set
- region to initial region
- searchText to empty*
- suggestions to empty (nil) or previous searches (but not yet clear how to specify this requirement, so go with empty/nil for now)
- address state to none

Map zoom and pan interactions and search address by coordinate API
- for the purpose of search address by coordinate we observe map (i.e., coordinate region) center
- to prevent “state changes while view updates” error…
    - use a separate callback, not a direct binding (and make @ Published property `private(set)`)
    - dispatch asynchronously
        - wrap in DispatchQueue.main.async, or (better)
        - make a subject and a pipeline with `.receive(on:)` and `.assign(to: &$region)`. This subject could be reused for search result - address with coordinate region - selection to set region. This pipeline is a separate one, that does not involve or initiate coordinate (or other) search - make test that proves this - search spy should confirm no API calls.
- when region center changes search API is been called - use spy
- region center change should result in address state change on successful API call
- region center change should not change address state change on failing API call
- region center changes should be debounced to prevent excessive API usage - use schedulers
- remove duplicates: region center change should exceed certain threshold to be considered “changed” - that is a separate functionality/responsibility involving geo math (see wiki) should implement
- this pipeline should return on the main thread (receive on)

#### Search field
- on search activation set state to `.search`
    - could be kinda substituted with callback for searchText change
    - …if you need to detect when the interface is active, you can query the environment’s isSearching property.
    - isSearching | Apple Developer Documentation
    - When the user first taps or clicks in a search field, the isSearching property becomes true. When the user cancels the search operation, the property becomes false. To programmatically set the value to false and dismiss the search operation, use dismissSearch.
    - ! observe property in the child view (! see example in docs and DismissibleView) and pass it to the view model callback: this callback would set state to `.search` if true; no need to change the state if false
- on dismiss set state to map/zoom and pan; or search to none
- on empty searchText show empty suggestions (or prev searches - see note)
- debounce
- remove duplicates
- suggestions should be empty if no completions returned by API** - it’s a non-failing API call, just empty
- should have empty completions for non empty searchText on failing API call
- should have non empty completions for non empty searchText on non-failing API call
- committing search should call search API with searchText
- selecting suggested completion should call search API with completion
- selecting suggested completion should not call other search APIs
- selecting completion should be possible only from provided completions
- selecting completion should set address state to searching
- selecting search result should be possible from provided search results only
- selecting search result should set address to the address in selected result
- selecting search result should set coordinate region to region in selected search result - via subject (?), see Map interactions
- selecting search result should not trigger any searches - use spy for every API to prove
- selecting search result should dismiss search - subject that is observed in the view and call dismissSearch | Apple Developer Documentation
- selecting search result should reset searchText // note that dismissSearch clears any text from the search field and removes focus from the search field
- selecting search result should reset suggestions

### Qs
Should we cache search completions and search results?
How to store searches - not implementation but how to reason about this? Search completions could be used to make search without committing - what should be stored in this case, completion, or completion with search text?

*__ another way would be to see this as navigation destination case .search(String) allowing navigation and deep linking

**__ how to communicate no completions in UI? - just an empty list?

