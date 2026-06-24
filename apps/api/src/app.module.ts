import { Module } from '@nestjs/common';

import { VenuesModule } from './modules/venues/venues.module';

@Module({
  imports: [VenuesModule],
})
export class AppModule {}
