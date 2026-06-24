export type VenueCategory = 'water_park' | 'amusement_park';

export interface Venue {
  id: string;
  name: string;
  category: VenueCategory;
  region: string;
  description: string;
}
