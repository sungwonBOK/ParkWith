import { VenuesRepository } from './venues.repository';
import { VenuesService } from './venues.service';

describe('VenuesService', () => {
  it('lists the eight MVP seed venues', () => {
    const service = new VenuesService(new VenuesRepository());

    const venues = service.listVenues();

    expect(venues).toHaveLength(8);
    expect(venues).toContainEqual(
      expect.objectContaining({
        id: 'caribbean-bay',
        name: 'Caribbean Bay',
        category: 'water_park',
      }),
    );
  });
});
