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
        nameKo: '캐리비안 베이',
        category: 'water_park',
      }),
    );
  });

  it('finds a venue by id', () => {
    const service = new VenuesService(new VenuesRepository());

    const venue = service.findVenueById('everland');

    expect(venue).toEqual(
      expect.objectContaining({
        id: 'everland',
        name: 'Everland',
      }),
    );
  });

  it('returns null for an unknown venue id', () => {
    const service = new VenuesService(new VenuesRepository());

    const venue = service.findVenueById('unknown-venue');

    expect(venue).toBeNull();
  });
});
