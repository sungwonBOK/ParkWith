import { Venue } from '../entities/venue.entity';

export interface VenueDto {
  id: string;
  name: string;
  category: Venue['category'];
  region: string;
  description: string;
}

export interface VenueListResponseDto {
  success: true;
  data: VenueDto[];
  error: null;
}
