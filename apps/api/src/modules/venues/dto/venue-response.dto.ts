import { Venue } from '../entities/venue.entity';

export interface VenueDto {
  id: string;
  name: string;
  nameKo: string;
  category: Venue['category'];
  region: string;
  description: string;
}

export interface VenueListResponseDto {
  success: true;
  data: VenueDto[];
  error: null;
}

export interface ApiErrorDto {
  code: string;
  message: string;
}

export type VenueDetailResponseDto =
  | {
      success: true;
      data: VenueDto;
      error: null;
    }
  | {
      success: false;
      data: null;
      error: ApiErrorDto;
    };
