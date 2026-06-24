import { Controller, Get } from '@nestjs/common';

import { VenueListResponseDto } from './dto/venue-response.dto';
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
}
