import { Controller, Get, Param } from '@nestjs/common';

import {
  DealListResponseDto,
  VenueDetailResponseDto,
  VenueListResponseDto,
} from './dto/venue-response.dto';
import { DealsService } from './deals.service';
import { VenuesService } from './venues.service';

@Controller('venues')
export class VenuesController {
  constructor(
    private readonly venuesService: VenuesService,
    private readonly dealsService: DealsService,
  ) {}

  @Get()
  listVenues(): VenueListResponseDto {
    return {
      success: true,
      data: this.venuesService.listVenues(),
      error: null,
    };
  }

  @Get(':venueId/deals')
  listVenueDeals(@Param('venueId') venueId: string): DealListResponseDto {
    return {
      success: true,
      data: this.dealsService.listDealsForVenue(venueId),
      error: null,
    };
  }

  @Get(':venueId')
  getVenue(@Param('venueId') venueId: string): VenueDetailResponseDto {
    const venue = this.venuesService.findVenueById(venueId);

    if (venue === null) {
      return {
        success: false,
        data: null,
        error: {
          code: 'VENUE_NOT_FOUND',
          message: 'Venue could not be found.',
        },
      };
    }

    return {
      success: true,
      data: venue,
      error: null,
    };
  }
}
