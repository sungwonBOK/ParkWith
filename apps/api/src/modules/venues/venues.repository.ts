import { Injectable } from '@nestjs/common';

import { Venue } from './entities/venue.entity';
import { venueSeedData } from './venues.seed';

@Injectable()
export class VenuesRepository {
  findAll(): Venue[] {
    return [...venueSeedData];
  }
}
