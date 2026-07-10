import { DealsRepository } from './deals.repository';
import { DealsService } from './deals.service';
import { VenuesController } from './venues.controller';
import { VenuesRepository } from './venues.repository';
import { VenuesService } from './venues.service';

describe('VenuesController', () => {
  const createController = () =>
    new VenuesController(
      new VenuesService(new VenuesRepository()),
      new DealsService(new DealsRepository()),
    );

  it('wraps venues in the API response envelope', () => {
    const controller = createController();

    const response = controller.listVenues();

    expect(response.success).toBe(true);
    expect(response.error).toBeNull();
    expect(response.data).toHaveLength(8);
  });

  it('wraps a venue detail in the API response envelope', () => {
    const controller = createController();

    const response = controller.getVenue('everland');

    expect(response.success).toBe(true);
    expect(response.error).toBeNull();
    expect(response.data).toEqual(
      expect.objectContaining({
        id: 'everland',
        name: 'Everland',
      }),
    );
  });

  it('returns a safe error envelope for an unknown venue id', () => {
    const controller = createController();

    const response = controller.getVenue('unknown-venue');

    expect(response.success).toBe(false);
    expect(response.data).toBeNull();
    expect(response.error).toEqual({
      code: 'VENUE_NOT_FOUND',
      message: 'Venue could not be found.',
    });
  });

  it('lists seed deals for a venue with freshness metadata', () => {
    const controller = createController();

    const response = controller.listVenueDeals('everland');

    expect(response.success).toBe(true);
    expect(response.error).toBeNull();
    expect(response.data.length).toBeGreaterThan(0);
    expect(response.data).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          venueId: 'everland',
          title: expect.any(String),
          lastUpdatedAt: expect.stringMatching(/^\d{4}-\d{2}-\d{2}$/),
        }),
      ]),
    );
    expect(response.data.every((deal) => deal.venueId === 'everland')).toBe(
      true,
    );
  });
});
