% Hotel Recommendation System in Prolog

% Facts to store hotel details: name, star rating, price, amenities, location.
% hotel(Name, StarRating, Price, [Amenities], Location).

:- discontiguous hotel/5.

hotel('Hotel California', 5, 150, [wifi, breakfast, gym, pool], 'Los Angeles').
hotel('Sunset Inn', 3, 90, [wifi, breakfast], 'San Francisco').
hotel('Mountain Lodge', 4, 120, [wifi, breakfast, gym], 'Mountain View').
hotel('Budget Stay', 2, 50, [wifi], 'San Diego').
hotel('Seaside Retreat', 4, 200, [wifi, breakfast, gym, pool, spa], 'Miami').
hotel('Urban Oasis', 3, 80, [wifi, breakfast, gym], 'New York').
hotel('Country Comfort', 3, 75, [wifi, breakfast, pet_friendly], 'Austin').
hotel('Luxury Palace', 5, 300, [wifi, breakfast, gym, spa, pool, valet_parking], 'Las Vegas').
hotel('Green Valley', 4, 110, [wifi, breakfast, parking, gym], 'Denver').
hotel('City Lights', 3, 95, [wifi, breakfast, parking], 'Chicago').

% Distance from point of interest (e.g., city center) in km
% distance(Hotel, Distance).
distance('Hotel California', 5).
distance('Sunset Inn', 2).
distance('Mountain Lodge', 15).
distance('Budget Stay', 20).
distance('Seaside Retreat', 8).
distance('Urban Oasis', 3).
distance('Country Comfort', 12).
distance('Luxury Palace', 1).
distance('Green Valley', 10).
distance('City Lights', 4).

% Defining Relations by Rules
% Rule to find hotels based on star rating, price, required amenities, and location.
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, Output: Hotel
recommend_hotel(StarRating, MaxPrice, RequiredAmenities, Location, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    subset(RequiredAmenities, Amenities).

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
user_rating('Hotel California', 4.5).
user_rating('Sunset Inn', 3.8).
user_rating('Mountain Lodge', 4.2).
user_rating('Budget Stay', 2.5).
user_rating('Seaside Retreat', 4.7).
user_rating('Urban Oasis', 4.0).
user_rating('Country Comfort', 3.9).
user_rating('Luxury Palace', 4.9).
user_rating('Green Valley', 4.1).
user_rating('City Lights', 3.6).

% Rule to find hotels based on star rating, price, required amenities, location, and minimum user rating.
% Input: StarRating (minimum), MaxPrice, RequiredAmenities (list), Location, MinRating, Output: Hotel
recommend_hotel_with_rating(StarRating, MaxPrice, RequiredAmenities, Location, MinRating, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities, Location),
    user_rating(Hotel, Rating),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    Rating >= MinRating,
    subset(RequiredAmenities, Amenities).

% Seasonal Price Variation
% seasonal_price(Hotel, Season, Price).
seasonal_price('Hotel California', winter, 120).
seasonal_price('Hotel California', summer, 180).
seasonal_price('Seaside Retreat', winter, 180).
seasonal_price('Seaside Retreat', summer, 220).

% Rule to recommend hotels based on seasonal price.
% Input: StarRating (minimum), Season, MaxPrice, RequiredAmenities (list), Location, Output: Hotel
recommend_hotel_seasonal(StarRating, Season, MaxPrice, RequiredAmenities, Location, Hotel) :-
    seasonal_price(Hotel, Season, Price),
    hotel(Hotel, HotelStarRating, _, Amenities, Location),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    subset(RequiredAmenities, Amenities).

% Rule to recommend hotels based on distance from a point of interest.
% Input: MaxDistance, Output: Hotel
recommend_hotel_by_distance(MaxDistance, Hotel) :-
    distance(Hotel, Distance),
    Distance =< MaxDistance.

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
    subset(RequiredAmenities, Amenities).

% Hotel Categories
% category(Hotel, Category).
category('Hotel California', luxury).
category('Sunset Inn', mid_range).
category('Budget Stay', budget).
category('Seaside Retreat', luxury).
category('Urban Oasis', mid_range).
category('Country Comfort', mid_range).
category('Luxury Palace', luxury).
category('Green Valley', mid_range).
category('City Lights', mid_range).

% Rule for filtering hotels by category.
% Input: Category, Output: Hotel
recommend_by_category(Category, Hotel) :-
    category(Hotel, Category).

% Amenities Scoring System
% Score hotels based on the number of amenities provided.
% Input: Hotel, Output: Score
amenities_score(Hotel, Score) :-
    hotel(Hotel, _, _, Amenities, _),
    length(Amenities, Score).

% Room Availability and Booking System
% room_availability(Hotel, Rooms).
room_availability('Hotel California', 10).
room_availability('Sunset Inn', 5).
room_availability('Budget Stay', 0).
room_availability('Seaside Retreat', 3).
room_availability('Urban Oasis', 7).
room_availability('Country Comfort', 2).
room_availability('Luxury Palace', 4).
room_availability('Green Valley', 8).
room_availability('City Lights', 6).

% Rule to check room availability.
% Input: Hotel, Output: Availability (true/false)
is_room_available(Hotel) :-
    room_availability(Hotel, Rooms),
    Rooms > 0.

% Rule to book a room.
% Input: Hotel, Output: Updated Room Availability
book_room(Hotel) :-
    room_availability(Hotel, Rooms),
    Rooms > 0,
    NewRooms is Rooms - 1,
    retract(room_availability(Hotel, Rooms)),
    assert(room_availability(Hotel, NewRooms)).

% Dynamic Pricing Based on Demand
% Adjust price based on room availability.
% Input: Hotel, Season, Output: AdjustedPrice
dynamic_price(Hotel, Season, AdjustedPrice) :-
    seasonal_price(Hotel, Season, BasePrice),
    room_availability(Hotel, Rooms),
    (Rooms < 5 -> AdjustedPrice is BasePrice * 1.5 ; AdjustedPrice is BasePrice).

% Sample Queries
% Queries to find hotels based on different criteria.
% ?- recommend_hotel(3, 100, [wifi, breakfast], 'San Francisco', Hotel).
% This query will return hotels in San Francisco that have at least a 3-star rating, cost under $100, and provide both wifi and breakfast.

% ?- recommend_hotel_with_rating(4, 150, [gym, breakfast], 'Mountain View', 4.0, Hotel).
% This query will return hotels in Mountain View that have at least a 4-star rating, cost under $150, provide both a gym and breakfast, and have a user rating of at least 4.0.

% ?- recommend_hotel_seasonal(4, winter, 130, [wifi, breakfast], 'Los Angeles', Hotel).
% This query will return hotels in Los Angeles that have at least a 4-star rating, a seasonal price under $130 in winter, and provide both wifi and breakfast.

% ?- recommend_hotel_by_distance(10, Hotel).
% This query will return hotels that are within 10 km of the city center.

% ?- recommend_advanced(4, 200, [wifi, breakfast], 'Mountain View', 4.0, 10, Hotel).
% This query will return hotels that meet all given criteria including distance.

% ?- recommend_by_category(luxury, Hotel).
% This query will return all luxury hotels.

% ?- amenities_score('Hotel California', Score).
% This query will return the amenities score for 'Hotel California'.

% ?- is_room_available('Hotel California').
% This query will check if rooms are available at 'Hotel California'.

% ?- book_room('Hotel California').
% This query will book a room at 'Hotel California' if available.

% ?- dynamic_price('Hotel California', summer, Price).
% This query will return the dynamic price for 'Hotel California' during the summer based on room availability.
