export type VenueCategory = 'water_park' | 'amusement_park';

export interface Venue {
  id: string;
  name: string;
  nameKo: string;
  category: VenueCategory;
  region: string;
  description: string;
}
