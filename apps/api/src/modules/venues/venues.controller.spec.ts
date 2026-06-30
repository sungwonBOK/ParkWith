import { VenuesController } from './venues.controller';
import { VenuesRepository } from './venues.repository';
import { VenuesService } from './venues.service';

describe('VenuesController', () => {
  it('wraps venues in the API response envelope', () => {
    const controller = new VenuesController(
      new VenuesService(new VenuesRepository()),
    );

    const response = controller.listVenues();

    expect(response.success).toBe(true);
    expect(response.error).toBeNull();
    expect(response.data).toHaveLength(8);
  });

  it('wraps a venue detail in the API response envelope', () => {
    const controller = new VenuesController(
      new VenuesService(new VenuesRepository()),
    );

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
    const controller = new VenuesController(
      new VenuesService(new VenuesRepository()),
    );

    const response = controller.getVenue('unknown-venue');

    expect(response.success).toBe(false);
    expect(response.data).toBeNull();
    expect(response.error).toEqual({
      code: 'VENUE_NOT_FOUND',
      message: 'Venue could not be found.',
    });
  });
});
