# Privacy Reference

Use this reference when changing location data, photos, lost items, logs, admin access, or retention.

## Location Privacy

- Share real-time location only with members of the same trip room.
- Store latest location snapshots, not unlimited location history.
- Require `expiresAt` or an equivalent expiration policy for location snapshots.
- Delete or expire personally identifiable location data after the visit ends.
- Do not use location data for analysis without explicit user consent.

## Photo Privacy

- Photo flows can expose faces, phone numbers, cards, IDs, locker details, or car information.
- Show a privacy warning before photo upload in lost-item, saved-place, and visit-record flows.
- Users must be able to delete uploaded photos when the feature owns the photo.

## Logging

Never log:

- precise coordinates
- phone numbers
- ID numbers
- card numbers
- API keys
- access or refresh tokens
- private object storage URLs that grant direct access

## Admin Access

Do not expose individual real-time locations by default in admin features.

