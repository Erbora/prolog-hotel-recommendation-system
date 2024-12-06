% Hotel Recommendation System in Prolog

% Facts to store hotel details: name, star rating, price, amenities.
% hotel(Name, StarRating, Price, [Amenities]).

hotel('Hotel California', 5, 150, [wifi, breakfast, gym, pool]).
hotel('Sunset Inn', 3, 90, [wifi, breakfast]).
hotel('Mountain Lodge', 4, 120, [wifi, breakfast, gym]).
hotel('Budget Stay', 2, 50, [wifi]).
hotel('Seaside Retreat', 4, 200, [wifi, breakfast, gym, pool, spa]).
hotel('Urban Oasis', 3, 80, [wifi, breakfast, gym]).
hotel('Country Comfort', 3, 75, [wifi, breakfast]).
hotel('Luxury Palace', 5, 300, [wifi, breakfast, gym, spa, pool, valet_parking]).

% Defining Relations by Rules
% Rule to find hotels based on star rating, price, and required amenities.
recommend_hotel(StarRating, MaxPrice, RequiredAmenities, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities),
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
recommend_hotel_universal(StarRating, MaxPrice, RequiredAmenities, Hotel) :-
    hotel(Hotel, HotelStarRating, Price, Amenities),
    HotelStarRating >= StarRating,
    Price =< MaxPrice,
    all_amenities_present(RequiredAmenities, Amenities).

% Defining Relations by Facts
% Additional hotel data for testing.
hotel('Green Valley', 4, 110, [wifi, breakfast, parking, gym]).
hotel('City Lights', 3, 95, [wifi, breakfast, parking]).

% Sample Queries
% Queries to find hotels based on different criteria.
% ?- recommend_hotel(3, 100, [wifi, breakfast], Hotel).
% This query will return hotels that have at least a 3-star rating, cost under $100, and provide both wifi and breakfast.

% Composite Queries
% ?- recommend_hotel(4, 150, [gym, breakfast], Hotel).
% This query will return hotels that have at least a 4-star rating, cost under $150, and provide both a gym and breakfast.

% ?- recommend_hotel_universal(3, 100, [wifi, breakfast], Hotel).
% This query uses universal quantification to ensure all required amenities are present.

% Matching and Unification in Queries
% Example of matching and unification to find specific hotel attributes.
% ?- hotel(Name, 5, Price, Amenities), member(pool, Amenities).
% This query will find 5-star hotels that have a pool.

% Logic Programming Concepts
% Using Prolog's logical inference to define hotel recommendations based on user preferences.
