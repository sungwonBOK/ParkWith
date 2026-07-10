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

export interface DealDto {
  id: string;
  venueId: string;
  title: string;
  summary: string;
  discountText: string;
  sourceUrl: string;
  lastUpdatedAt: string;
}

export interface DealListResponseDto {
  success: true;
  data: DealDto[];
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
