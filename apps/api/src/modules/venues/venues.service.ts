import { Injectable } from '@nestjs/common';

import { Venue } from './entities/venue.entity';
import { VenuesRepository } from './venues.repository';

@Injectable()
export class VenuesService {
  constructor(private readonly venuesRepository: VenuesRepository) {}

  listVenues(): Venue[] {
    return this.venuesRepository.findAll();
  }

  findVenueById(venueId: string): Venue | null {
    return this.venuesRepository.findById(venueId);
  }
}
