___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Platform Items Mapper (sGTM)",
  "description": "Map GA4 items to platform-specific arrays for dynamic remarketing: Google Ads (items), Meta/TikTok (contents), Pinterest (line_items), Snapchat (item_ids).",
  "categories": ["ADVERTISING", "CONVERSIONS", "ANALYTICS"],
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "itemsInput",
    "displayName": "Items Variable",
    "simpleValueType": true,
    "help": "Pass a variable that resolves to GA4 items array (e.g., {{ecommerce.items}} or a custom var that returns the array)"
  },
  {
    "type": "SELECT",
    "name": "platform",
    "displayName": "",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "remarketing",
        "displayValue": "Google Ads Remarketing"
      },
      {
        "value": "meta",
        "displayValue": "Meta Pixel"
      },
      {
        "value": "tiktok",
        "displayValue": "Tiktok Pixel"
      },
      {
        "value": "pinterest",
        "displayValue": "Pinterest Pixel"
      },
      {
        "value": "snapchat",
        "displayValue": "Snapchat Pixel"
      }
    ],
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

// Simple array checker (sandbox-safe)
function isArr(v) { return !!(v && typeof v.length === 'number' && typeof v !== 'string'); }

// Number coercion without Number()/parseFloat()
function num(v, fallback) {
  var base = (typeof fallback === 'number') ? fallback : 0;
  var n = 1 * (v == null ? base : v);
  return (n !== n) ? base : n; // NaN guard
}
function qNum(v, fallback) { return num(v, (typeof fallback === 'number') ? fallback : 1); }

// Round to micros without Math
function roundMicros(val) {
  var n = 1 * val;
  if (n !== n) return 0;                // NaN guard
  return (n * 1000000 + 0.5) >> 0;      // floor to int
}

// Extract GA4 items array from input
function coerceItems(input) {
  if (isArr(input)) return input;
  if (input && isArr(input.items)) return input.items;
  return undefined;
}

// Get a product id from an item object
function pickId(i) { return i.item_id || i.id || i.sku || i.itemId || ''; }

// === Read user inputs ===
var platform = data.platform;    // 'cart' | 'cart_api' | 'remarketing' | 'meta' | 'tiktok' | 'pinterest' | 'snapchat'
var itemsArg = data.itemsInput;  // variable resolving to GA4 items array/object

// Resolve items
var items = coerceItems(itemsArg);

// If invalid, return empty array (never false)
if (!isArr(items) || items.length === 0) { return []; }

// Build outputs (arrays only)
switch (platform) {
  case 'cart':
    // Google Ads cart data (tag parameters): id, price, quantity
    return items.map(function (i) {
      return {
        id: pickId(i),
        price: num(i.price || i.item_price, 0),
        quantity: qNum(i.quantity, 1)
      };
    });

  case 'remarketing':
    // Google Ads Dynamic Remarketing (gtag-style minimal)
    return items.map(function (i) {
      return { id: pickId(i), google_business_vertical: 'retail' };
    });

  case 'meta':
    // Meta: id + quantity only
    return items.map(function (i) {
      return { id: pickId(i), quantity: qNum(i.quantity, 1) };
    });

  case 'tiktok':
    // TikTok: content_id + quantity
    return items.map(function (i) {
      return { content_id: pickId(i), quantity: qNum(i.quantity, 1) };
    });

  case 'pinterest':
    // Pinterest: product_id + quantity
    return items.map(function (i) {
      return { product_id: pickId(i), quantity: qNum(i.quantity, 1) };
    });

  case 'snapchat':
    // Snapchat: array of IDs
    var ids = [];
    for (var k = 0; k < items.length; k++) {
      var pid = pickId(items[k]);
      if (pid && ids.indexOf(pid) === -1) ids.push(pid);
    }
    return ids;

  default:
    // Fallback: behave like Meta
    return items.map(function (i) {
      return { id: pickId(i), quantity: qNum(i.quantity, 1) };
    });
}


___TESTS___

scenarios: []


___NOTES___

Created on 05/11/2025, 16:09:30


