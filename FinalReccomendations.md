# 📊 E-Commerce Funnel & Marketing Analysis

### Final Recommendations

> SQL-driven analysis of traffic sources, the purchase funnel, and revenue, ending in three clear, data-backed actions.

---

## 🧭 Table of Contents

- [Snapshot](#-snapshot)
- [1. Traffic Source Performance](#1--traffic-source-performance)
- [2. Purchase Funnel](#2--purchase-funnel)
- [3. Revenue Overview](#3--revenue-overview)
- [Final Recommendations](#-final-recommendations)
- [Unit Economics Rules](#-unit-economics-rules)
- [Notes on the Data](#-notes-on-the-data)

---

## ⚡ Snapshot

| Visitors | Buyers | Orders | Revenue | Avg. Order Value |
|:-------:|:------:|:------:|:-------:|:----------------:|
| **4,291** | **709** | **709** | **76,191.82** | **107.46** |

---

## 1. 🚦 Traffic Source Performance

Which channels bring people in, and which ones turn them into buyers?

| Traffic Source | Views | Carts | Purchases | View → Cart | Cart → Purchase | Overall Conversion |
|:---------------|------:|------:|----------:|------------:|----------------:|-------------------:|
| Social         | 1,261 | 171   | 84        | 14%         | 49%             | **7%**             |
| Email          | 449   | 283   | 152       | 63%         | 54%             | **34%** 🏆         |
| Paid Ads       | 824   | 306   | 173       | 37%         | 57%             | **21%**            |
| Organic        | 1,757 | 578   | 300       | 33%         | 52%             | **17%**            |

**What this tells us**

- **Social brings volume, not buyers.** It supplies about 30% of all traffic but converts at only 7%, the lowest of any channel. Most of these visitors are browsing, not buying.
- **Email is the most efficient channel.** Only about 10% of traffic comes from email, yet it converts at 34%, nearly 5× social. Almost two-thirds of email visitors add something to their cart.
- **Paid ads convert well.** At 21%, they are the second-best channel and have the highest cart-to-purchase rate (57%).
- **Organic is the volume engine.** It is the largest source (about 41% of visits) with a solid 17% conversion.

---

## 2. 🔻 Purchase Funnel

Where do visitors drop off on the way to buying?

| Stage | Users | Step Conversion |
|:------|------:|----------------:|
| 1. View | 4,291 | — |
| 2. Cart | 1,338 | 31% of views |
| 3. Checkout | 954 | 71% of carts |
| 4. Payment | 770 | 81% of checkouts |
| 5. Purchase | 709 | 92% of payments |

**What this tells us**

- **The biggest leak is at the very top**: only 31% of visitors add anything to their cart. That is where the opportunity is.
- **Once people reach checkout, they finish.** Each later step keeps 71% to 92% of users, and the payment-to-purchase step is 92%. About 74% of people who start checkout complete a purchase.
- **The payment flow is healthy.** There is no sign of a technical or UX problem in the checkout path.

---

## 3. 💰 Revenue Overview

| Total Visitors | Total Buyers | Total Orders | Total Revenue | Avg. Order Value | Avg. Revenue / Buyer | Avg. Revenue / Visitor |
|--------------:|-------------:|-------------:|--------------:|-----------------:|---------------------:|-----------------------:|
| 4,291 | 709 | 709 | 76,191.82 | 107.46 | 107.46 | 17.76 |

**What this tells us**

- Each buyer places exactly one order (709 buyers = 709 orders), so there is **no repeat purchasing yet** in this dataset.
- The average order is worth about **107**, and every visitor is worth about **17.76** in revenue, buyer or not.
- Roughly **1 in 6 visitors (16.5%)** ends up buying.

---

## ✅ Final Recommendations

### 1️⃣ Marketing: Stop over-investing in social for sales

Social drives about 30% of traffic but has the lowest conversion rate (7%). We are likely paying for window shoppers.

> **Action:** Shift budget away from "Traffic" objectives on social ads toward **Retargeting** or **Lead Gen**, so the goal becomes capturing emails rather than clicks.

### 2️⃣ Marketing: Double down on email

Email is our highest-converting channel (34% vs. 7% for social).

> **Action:** Add an email-capture popup for high-volume social visitors. Once they are on our list, the data shows they are far more likely to buy later.

### 3️⃣ UX: Don't touch the checkout flow

Checkout is working. The step conversions of 81% (checkout to payment) and 92% (payment to purchase) mean the payment flow is frictionless.

> **Action:** Do not redesign the checkout page right now. You risk breaking something that is working perfectly. Put optimization effort into the **view → cart** step instead.

---

## 🧮 Unit Economics Rules

Two simple guardrails for any acquisition spending:

| Rule | Why it matters |
|:-----|:---------------|
| **AOV must be greater than CAC** | With an AOV of about 107, spending more than that to acquire a customer means we lose money on the first order. |
| **CLV should be at least 3× CAC** | Customer Lifetime Value needs to comfortably cover acquisition cost for growth to be sustainable. |

---

## 📝 Notes on the Data

- The original written recommendation quoted email at "~13%+" and social at "~6%". The query output above shows **34%** and **7%**, so this README uses the table values. The conclusion is unchanged: email far outperforms social.
- In the funnel query, the column named `overall_conversion` (92%) is actually the **payment → purchase** step. True end-to-end conversion (view → purchase) is **709 / 4,291 ≈ 16.5%**.
- AOV is based on revenue, not profit, so compare it against CAC with margins in mind.

---

<p align="center">Made with 📈 and SQL</p>
