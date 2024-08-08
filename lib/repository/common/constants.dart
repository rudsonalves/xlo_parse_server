// Copyright (C) 2024 Rudson Alves
//
// This file is part of xlo_parse_server.
//
// xlo_parse_server is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_parse_server is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_parse_server.  If not, see <https://www.gnu.org/licenses/>.

const maxAdsPerList = 20;

const keyUserId = 'objectId';
const keyUserName = 'username';
const keyUserNickname = 'nickname';
const keyUserEmail = 'email';
const keyUserPassword = 'password';
const keyUserPhone = 'phone';
const keyUserType = 'type';

const keyMechanicTable = 'Mechanics';
const keyMechanicId = 'objectId';
const keyMechanicName = 'name';
const keyMechanicDescription = 'description';

const keyAddressTable = 'Addresses';
const keyAddressId = 'objectId';
const keyAddressName = 'name';
const keyAddressZipCode = 'zipCode';
const keyAddressStreet = 'street';
const keyAddressNumber = 'number';
const keyAddressComplement = 'complement';
const keyAddressNeighborhood = 'neighborhood';
const keyAddressState = 'state';
const keyAddressCity = 'city';
const keyAddressOwner = 'owner';
const keyAddressCreatedAt = 'createdAt';

const keyAdTable = 'AdsSale';
const keyAdId = 'objectId';
const keyAdOwner = 'owner';
const keyAdTitle = 'title';
const keyAdBggId = 'bggId';
const keyAdDescription = 'description';
const keyAdHidePhone = 'hidePhone';
const keyAdPrice = 'price';
const keyAdStatus = 'status';
const keyAdMechanics = 'mechanic';
const keyAdImages = 'images';
const keyAdAddress = 'address';
const keyAdViews = 'views';
const keyAdCondition = 'condition';
const keyAdCreatedAt = 'createdAt';

const keyFavoriteTable = 'Favorites';
const keyFavoriteId = 'objectId';
const keyFavoriteOwner = 'owner';
const keyFavoriteAd = 'ad';
