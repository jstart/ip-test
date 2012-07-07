//
//
//  Copyright 2011 CityGrid Media, LLC All rights reserved.
//
typedef enum {
	CGErrorNumUnknown = -1,
	CGErrorNumUnderspecified = 1,
	CGErrorNumQueryTypeUnknown = 2,
	CGErrorNumQueryOverspecified = 3,
	CGErrorNumGeographyUnderspecified = 4,
	CGErrorNumGeographyOverspecified = 5,
	CGErrorNumRadiusRequired = 6,
	CGErrorNumDatePast = 7,
	CGErrorNumDateRangeIncomplete = 8,
	CGErrorNumDateRangeTooLong = 9,
	CGErrorNumGeocodeFailure = 10,
	CGErrorNumTagIllegal = 11,
	CGErrorNumChainIllegal = 12,
	CGErrorNumFirstIllegal = 13,
	CGErrorNumLatitudeIllegal = 14,
	CGErrorNumLongitudeIllegal = 15,
	CGErrorNumRadiusIllegal = 16,
	CGErrorNumPageIllegal = 17,
	CGErrorNumResultsPerPageIllegal = 18,
	CGErrorNumFromIllegal = 19,
	CGErrorNumToIllegal = 20,
	CGErrorNumSortIllegal = 21,
	CGErrorNumRadiusOutOfRange = 22,
	CGErrorNumPageOutOfRange = 23,
	CGErrorNumResultsPerPageOutOfRange = 24,
	CGErrorNumPublisherRequired = 25,
	CGErrorNumInternal = 26,
	CGErrorNumListingNotFound = 27,
	CGErrorNumNetworkError = 28,
	CGErrorNumParseError = 29,
	CGErrorNumPhoneIllegal = 30,
	CGErrorNumLocationIdOutOfRange = 31,
	CGErrorNumInfoUsaIdOutOfRange = 32,
	CGErrorNumReviewCountOutOfRange = 33,
	CGErrorNumReviewRatingOutOfRange = 34,
	CGErrorNumReviewDaysOutOfRange = 35,
	CGErrorNumOfferIdRequired = 36,
	CGErrorNumMaxOutOfRange = 37,
	CGErrorNumCollectionRequired = 38,
	CGErrorNumSizeRequired = 39,
	CGErrorNumActionTargetRequired = 40,
	CGErrorNumLocationIdRequired = 41,
	CGErrorNumReferenceIdRequired = 42,
	CGErrorNumDialPhoneRequired = 43,
	CGErrorNumSimulationNotFound = 44,
    CGErrorNumIdTypeNotFound = 45,
    CGErrorNumPublicIdNotFound = 46
} CGErrorNum;
