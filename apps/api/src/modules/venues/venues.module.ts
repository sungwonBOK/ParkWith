import { Module } from '@nestjs/common';

import { DealsRepository } from './deals.repository';
import { DealsService } from './deals.service';
import { VenuesController } from './venues.controller';
import { VenuesRepository } from './venues.repository';
import { VenuesService } from './venues.service';

@Module({
  controllers: [VenuesController],
  providers: [DealsRepository, DealsService, VenuesRepository, VenuesService],
})
export class VenuesModule {}
