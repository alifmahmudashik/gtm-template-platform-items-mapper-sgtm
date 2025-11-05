# 🧩 Platform Items Mapper (sGTM)

## 📘 Overview

The **Platform Items Mapper (sGTM)** variable converts a **GA4-style items array** into the correct structure required for various advertising platforms, such as **Google Ads**, **Meta (Facebook)**, **TikTok**, **Pinterest**, and **Snapchat**.

Each platform uses a slightly different parameter format for its remarketing or conversion tags. This variable automatically reformats your GA4 `items` data to the correct array shape, ready to be used in your server-side tagging setup.

---

## ⚙️ Key Features

✅ Maps GA4 `items` array to platform-specific structures
✅ Supports **Google Ads Remarketing**, **Meta Pixel**, **TikTok**, **Pinterest**, and **Snapchat**
✅ Automatically detects product ID from `item_id`, `id`, `sku`, or `itemId`
✅ Provides consistent quantity and price handling
✅ Returns a clean, validated array (never `null` or `false`)

---

## 🚀 Use Cases

* Simplify dynamic remarketing tag setups across multiple platforms
* Send standardized ecommerce data from **Server-Side GTM**
* Reuse your GA4 `items` data for all marketing pixels without custom code
* Maintain consistent product identifiers and quantities across ad platforms

---

## 🧠 How It Works

1. The variable reads a GA4-style `items` array (or an object containing it).
2. It extracts product identifiers and quantities.
3. Based on your selected **Platform**, it returns the properly formatted array:

   * **Google Ads Remarketing** → `{ id, google_business_vertical: 'retail' }`
   * **Meta Pixel** → `{ id, quantity }`
   * **TikTok Pixel** → `{ content_id, quantity }`
   * **Pinterest Pixel** → `{ product_id, quantity }`
   * **Snapchat Pixel** → `[ 'id', 'id', ... ]`
   * **Google Ads Cart** (optional) → `{ id, price, quantity }`

If no items are found, it safely returns an **empty array** (`[]`).

---

## 🧩 Fields

| Field          | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| **itemsInput** | A variable that resolves to GA4 `items` (e.g., `{{ecommerce.items}}`) or an object with `items`.     |
| **platform**   | Choose which platform array structure to generate: Google Ads, Meta, TikTok, Pinterest, or Snapchat. |

---

## 🔒 Requirements

* **Server-Side Google Tag Manager** environment
* A variable that provides a GA4 `items` array or equivalent
* No external permissions required

---

## 🌐 Author

**Developed by:** [Alif Mahmud](https://alifmahmud.com)
**Website:** [https://alifmahmud.com](https://alifmahmud.com)
**Expertise:** Google Tag Manager, GA4, Server-Side Tracking, Dynamic Remarketing