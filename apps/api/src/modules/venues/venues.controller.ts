import { Controller, Get, Param } from '@nestjs/common';

import {
  VenueDetailResponseDto,
  VenueListResponseDto,
} from './dto/venue-response.dto';
import { VenuesService } from './venues.service';

@Controller('venues')
export class VenuesController {
  constructor(private readonly venuesService: VenuesService) {}

  @Get()
  listVenues(): VenueListResponseDto {
    return {
      success: true,
      data: this.venuesService.listVenues(),
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
