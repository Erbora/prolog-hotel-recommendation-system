% Hotel Recommendation System in Prolog

% Facts to store hotel details: name, star rating, price, amenities, location.
% hotel(Name, StarRating, Price, [Amenities], Location).

:- discontiguous hotel/5.

hotel('Hotel Alexandar Square', 5, 150, [wifi, breakfast, gym, pool], 'Skopje').
hotel('Hotel Arka', 4, 120, [wifi, breakfast, gym, pool], 'Skopje').
hotel('Hotel Lirak', 4, 100, [wifi, breakfast, gym], 'Tetovo').
hotel('Hotel Emka', 3, 90, [wifi, breakfast], 'Tetovo').
hotel('Hotel Solun', 5, 200, [wifi, breakfast, gym, pool, spa], 'Skopje').
hotel('Hotel City Park', 3, 80, [wifi, breakfast, gym], 'Skopje').
hotel('Hotel Kitka', 3, 75, [wifi, breakfast, pet_friendly], 'Tetovo').
hotel('Hotel Stone Bridge', 5, 300, [wifi, breakfast, gym, spa, pool, valet_parking], 'Skopje').
hotel('Hotel Square', 4, 110, [wifi, breakfast, parking, gym], 'Skopje').
hotel('Hotel View Inn', 3, 95, [wifi, breakfast, parking], 'Skopje').

% Distance from point of interest (e.g., city center) in km
% distance(Hotel, Distance).
distance('Hotel Alexandar Square', 1).
distance('Hotel Arka', 1.5).
distance('Hotel Lirak', 0.5).
distance('Hotel Emka', 2).
distance('Hotel Solun', 1).
distance('Hotel City Park', 2).
distance('Hotel Kitka', 1).
distance('Hotel Stone Bridge', 0.3).
distance('Hotel Square', 1.5).
distance('Hotel View Inn', 2).

% Defining Relations by Rules
% Rule to find hotels based on star rating, price, required amenities, and location.
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, Output: Hotel
recommend_hotel(StarRating, MaxPrice, RequiredAmenities, Location, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    subset(RequiredAmenities, Amenities),
    format('Recommended Hotel: ~w (Star Rating: ~w, Price: $~w)', [Hotel, HotelStarRating, Price]),
    !.
recommend_hotel(_, _, _, _, _) :-
    write('No hotels found matching the given criteria.'), nl, fail.

% Helper predicate to check if all elements of one list are in another.
% Recursive Rules
subset([], _).
subset([H|T], List) :-
    member(H, List),
    subset(T, List).

% Universal Quantification
% To ensure that all elements in RequiredAmenities are in Amenities.
all_amenities_present(RequiredAmenities, Amenities) :-
    forall(member(Amenity, RequiredAmenities), member(Amenity, Amenities)).

% Alternative rule using universal quantification to recommend hotels.
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, Output: Hotel
recommend_hotel_universal(StarRating, MaxPrice, RequiredAmenities, Location, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    all_amenities_present(RequiredAmenities, Amenities).

% User Ratings and Reviews
% user_rating(Hotel, Rating).
user_rating('Hotel Alexandar Square', 4.5).
user_rating('Hotel Arka', 4.2).
user_rating('Hotel Lirak', 4.3).
user_rating('Hotel Emka', 3.8).
user_rating('Hotel Solun', 4.7).
user_rating('Hotel City Park', 4.0).
user_rating('Hotel Kitka', 3.9).
user_rating('Hotel Stone Bridge', 4.9).
user_rating('Hotel Square', 4.1).
user_rating('Hotel View Inn', 3.6).

% Rule to find hotels based on star rating, price, required amenities, location, and minimum user rating.
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, MinRating, Output: Hotel
recommend_hotel_with_rating(StarRating, MaxPrice, RequiredAmenities, Location, MinRating, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    user_rating(Hotel, Rating),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    Rating >= MinRating,
    subset(RequiredAmenities, Amenities),
    format('Recommended Hotel: ~w (Star Rating: ~w, Price: $~w, User Rating: ~w)', [Hotel, HotelStarRating, Price, Rating]),
    !.
recommend_hotel_with_rating(_, _, _, _, _, _) :-
    write('No hotels found matching the given criteria and rating.'), nl, fail.

% Seasonal Price Variation
% seasonal_price(Hotel, Season, Price).
seasonal_price('Hotel Alexandar Square', winter, 120).
seasonal_price('Hotel Alexandar Square', summer, 180).
seasonal_price('Hotel Solun', winter, 180).
seasonal_price('Hotel Solun', summer, 220).

% Rule to recommend hotels based on seasonal price.
% Input: StarRating (minimum), Season, MaxPrice, RequiredAmenities (list), Location, Output: Hotel
recommend_hotel_seasonal(StarRating, Season, MaxPrice, RequiredAmenities, Location, Hotel) :-
    seasonal_price(Hotel, Season, Price),
    hotel(Hotel, HotelStarRating, _, Amenities, Location),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    subset(RequiredAmenities, Amenities),
    format('Recommended Hotel: ~w (Star Rating: ~w, Seasonal Price: $~w, Season: ~w)', [Hotel, HotelStarRating, Price, Season]),
    !.
recommend_hotel_seasonal(_, _, _, _, _, _) :-
    write('No hotels found matching the seasonal price and criteria.'), nl, fail.

% Rule to recommend hotels based on distance from a point of interest.
% Input: MaxDistance, Output: Hotel
recommend_hotel_by_distance(MaxDistance, Hotel) :-
    distance(Hotel, Distance),
    Distance =< MaxDistance,
    format('Hotel within Distance: ~w (~w km)', [Hotel, Distance]),
    !.
recommend_hotel_by_distance(_) :-
    write('No hotels found within the specified distance.'), nl, fail.

% Advanced recommendation with combined criteria (star rating, price, amenities, location, rating, distance).
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, MinRating, MaxDistance, Output: Hotel
recommend_advanced(StarRating, MaxPrice, RequiredAmenities, Location, MinRating, MaxDistance, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    user_rating(Hotel, Rating),
    distance(Hotel, Distance),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    Rating >= MinRating,
    Distance =< MaxDistance,
    subset(RequiredAmenities, Amenities),
    format('Recommended Hotel: ~w (Star Rating: ~w, Price: $~w, User Rating: ~w, Distance: ~w km)', 
           [Hotel, HotelStarRating, Price, Rating, Distance]),
    !.
recommend_advanced(_, _, _, _, _, _, _) :-
    write('No hotels found meeting all advanced criteria.'), nl, fail.

% Hotel Categories
% category(Hotel, Category).
category('Hotel Alexandar Square', luxury).
category('Hotel Arka', mid_range).
category('Hotel Emka', mid_range).
category('Hotel Solun', luxury).
category('Hotel City Park', mid_range).
category('Hotel Kitka', mid_range).
category('Hotel Stone Bridge', luxury).
category('Hotel Square', mid_range).
category('Hotel View Inn', mid_range).

% Rule for filtering hotels by category.
% Input: Category, Output: Hotel
recommend_by_category(Category, Hotel) :-
    category(Hotel, Category),
    format('Hotel in Category ~w: ~w', [Category, Hotel]),
    !.
recommend_by_category(_) :-
    write('No hotels found for the specified category.'), nl, fail.

% Amenities Scoring System
% Score hotels based on the number of amenities provided.
% Input: Hotel, Output: Score
amenities_score(Hotel, Score) :-
    hotel(Hotel, _, _, Amenities, _),
    length(Amenities, Score).

:- dynamic room_availability/2.

% Room Availability and Booking System
% room_availability(Hotel, Rooms).
room_availability('Hotel Alexandar Square', 10).
room_availability('Hotel Arka', 5).
room_availability('Hotel Lirak', 3).
room_availability('Hotel Emka', 4).
room_availability('Hotel Solun', 3).
room_availability('Hotel City Park', 7).
room_availability('Hotel Kitka', 2).
room_availability('Hotel Stone Bridge', 4).
room_availability('Hotel Square', 8).
room_availability('Hotel View Inn', 6).

% Rule to check room availability.
% Input: Hotel, Output: Availability (true/false)
is_room_available(Hotel) :-
    room_availability(Hotel, Rooms),
    Rooms > 0,
    format('Rooms are available at ~w. (~w rooms left)', [Hotel, Rooms]),
    !.
is_room_available(Hotel) :-
    format('Sorry, there are no rooms available at ~w.', [Hotel]), nl, fail.


% Rule to book a room.
% Input: Hotel, Output: Updated Room Availability
book_room(Hotel) :-
    room_availability(Hotel, Rooms),
    Rooms > 0,
    NewRooms is Rooms - 1,
    retract(room_availability(Hotel, Rooms)),
    assert(room_availability(Hotel, NewRooms)),
    format('Room successfully booked at ~w. (~w rooms remaining)', [Hotel, NewRooms]),
    !.
book_room(Hotel) :-
    format('Booking failed: No rooms left at ~w.', [Hotel]), nl, fail.


% Dynamic Pricing Based on Demand
% Adjust price based on room availability.
% Input: Hotel, Season, Output: AdjustedPrice
dynamic_price(Hotel, Season, AdjustedPrice) :-
    seasonal_price(Hotel, Season, BasePrice),
    room_availability(Hotel, Rooms),
    (Rooms < 5 -> AdjustedPrice is BasePrice * 1.5 ; AdjustedPrice is BasePrice),
    format('The dynamic price for ~w in ~w season is $~2f.', [Hotel, Season, AdjustedPrice]),
    !.
dynamic_price(Hotel, Season, _) :-
    \+ seasonal_price(Hotel, Season, _),
    format('No seasonal price information available for ~w in ~w season.', [Hotel, Season]), nl, fail.


% Sample Queries
% ?- recommend_hotel(3, 100, [wifi, breakfast], 'Skopje', Hotel).

% ?- recommend_hotel_with_rating(4, 150, [gym, breakfast], 'Tetovo', 4.0, Hotel).

% ?- recommend_hotel_seasonal(4, winter, 130, [wifi, breakfast], 'Skopje', Hotel).

% ?- recommend_hotel_by_distance(2, Hotel).

% ?- recommend_advanced(4, 200, [wifi, breakfast], 'Tetovo', 4.0, 10, Hotel).

% ?- recommend_by_category(luxury, Hotel).

% ?- amenities_score('Hotel Alexandar Square', Score).

% ?- is_room_available('Hotel Alexandar Square').

% ?- book_room('Hotel Alexandar Square').

% ?- dynamic_price('Hotel Alexandar Square', summer, Price).
