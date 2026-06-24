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
});
