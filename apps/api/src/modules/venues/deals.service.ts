import { Injectable } from '@nestjs/common';

import { Deal } from './entities/deal.entity';
import { DealsRepository } from './deals.repository';

@Injectable()
export class DealsService {
  constructor(private readonly dealsRepository: DealsRepository) {}

  listDealsForVenue(venueId: string): Deal[] {
    return this.dealsRepository.findByVenueId(venueId);
  }
}
