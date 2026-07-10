import { Injectable } from '@nestjs/common';

import { Deal } from './entities/deal.entity';
import { dealSeedData } from './deals.seed';

@Injectable()
export class DealsRepository {
  findByVenueId(venueId: string): Deal[] {
    return dealSeedData.filter((deal) => deal.venueId === venueId);
  }
}
