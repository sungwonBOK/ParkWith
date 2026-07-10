import { Deal } from './entities/deal.entity';

export const dealSeedData: Deal[] = [
  {
    id: 'everland-afternoon-pass',
    venueId: 'everland',
    title: 'Afternoon pass discount',
    summary: 'Reduced admission after afternoon entry hours.',
    discountText: 'Up to 35% off selected afternoon passes',
    sourceUrl: 'https://www.everland.com/',
    lastUpdatedAt: '2026-06-30',
  },
  {
    id: 'everland-family-card',
    venueId: 'everland',
    title: 'Family card promotion',
    summary: 'Card-linked discount for family ticket purchases.',
    discountText: 'Card promotion varies by issuer',
    sourceUrl: 'https://www.everland.com/',
    lastUpdatedAt: '2026-06-30',
  },
  {
    id: 'caribbean-bay-early-bird',
    venueId: 'caribbean-bay',
    title: 'Early bird water park ticket',
    summary: 'Advance-purchase discount for dated water park tickets.',
    discountText: 'Early bird dated ticket discount',
    sourceUrl: 'https://www.everland.com/caribbeanbay/',
    lastUpdatedAt: '2026-06-30',
  },
  {
    id: 'lotte-world-seoul-online',
    venueId: 'lotte-world-adventure-seoul',
    title: 'Online admission promotion',
    summary: 'Online-only admission discount for Seoul park visitors.',
    discountText: 'Online ticket promotion',
    sourceUrl: 'https://adventure.lotteworld.com/',
    lastUpdatedAt: '2026-06-30',
  },
];
