# Shoppe Change Log

All notable changes to this project will be documented in this file.

The full commit history can be found [on GitHub](http://github.com/tryshoppe/core).

## Unreleased
* ...

## 1.1.2 - 2015-12-02

* Added missing es-US translation ([#258](https://github.com/tryshoppe/shoppe/pull/258))
* Added missing translation that failed to save categories ([#261](https://github.com/tryshoppe/shoppe/pull/261))
* Fix bug with product variants ([#262](https://github.com/tryshoppe/shoppe/pull/262))
* Fix issue with attachment uploader ([#266](https://github.com/tryshoppe/shoppe/pull/266))
* Adjusted phone number regex ([#276](https://github.com/tryshoppe/shoppe/pull/276))
* Added missing German translations ([#280](https://github.com/tryshoppe/shoppe/pull/280))
* Fixed `login_with_demo_mode` typo ([#281](https://github.com/tryshoppe/shoppe/pull/281))
* Fixed cut off payment button ([#282](https://github.com/tryshoppe/shoppe/pull/282))
* Fixed products import ([#285](https://github.com/tryshoppe/shoppe/pull/285))
* Update quantities on product import ([#286](https://github.com/tryshoppe/shoppe/pull/286))
* Added German translations to Customer section ([#287](https://github.com/tryshoppe/shoppe/pull/287))
* Improved Spanish translation ([#289](https://github.com/tryshoppe/shoppe/pull/289))
* Added Russian translation ([#295](https://github.com/tryshoppe/shoppe/pull/295))
* Fixed cost price German translation ([#299](https://github.com/tryshoppe/shoppe/pull/299))
* Fixed seeds when run twice ([#300](https://github.com/tryshoppe/shoppe/pull/300))
* Updated to Ruby 1.9 syntax ([#304](https://github.com/tryshoppe/shoppe/pull/304))

## 1.1.1 - 2015-08-09

* Bug with default_image_file ([#244](https://github.com/tryshoppe/shoppe/pull/244))

## 1.1.0 - 2015-07-07

* Bug with product category translations
* Product category image uploads

## v1.0.9

* Attachments ([#211](https://github.com/tryshoppe/shoppe/pull/211))
* Added rake task to help with migration from nifty-attachments to Attachments
* Fixed translation ([#205](https://github.com/tryshoppe/shoppe/pull/205))

## v1.0.8

* Localisations / Translations for Products & Product Categories
* Customers & Addresses ([#167](https://github.com/tryshoppe/shoppe/pull/167))

## v1.0.7

* Fix to seeds
* Product category hierarchy_array ([#194](https://github.com/tryshoppe/shoppe/pull/194))

## v1.0.6

* German translations ([#180](https://github.com/tryshoppe/shoppe/pull/180))
* Multiple product categories with nesting ([#137](https://github.com/tryshoppe/shoppe/pull/137))
* Added refund callback to Payment model 

## v1.0.5

* Added Customers ([#119](https://github.com/tryshoppe/shoppe/pull/119))

* Fixed creation of orders in admin interface

* Updated gemspec for Rails 4.2.0 ([#162](https://github.com/tryshoppe/shoppe/pull/162))

* Fixed issue where order callbacks weren't being executed on order `accept!` and `reject!` methods ([#166](https://github.com/tryshoppe/shoppe/pull/166))

## v1.0.4

* Added `items_sub_total` method to Orders

* Extracted text to locale files ([#83](https://github.com/tryshoppe/shoppe/pull/83))

* Polish translations

* Permalink Validations ([#127](https://github.com/tryshoppe/shoppe/pull/127))

* Moved Order email actions to separate methods ([#130](https://github.com/tryshoppe/shoppe/pull/130))

* Added index to all tables ([#131](https://github.com/tryshoppe/shoppe/pull/131))

* Spanish translations ([#135](https://github.com/tryshoppe/shoppe/pull/135))

* Fixed HAML render error & added support for decorators ([#138](https://github.com/tryshoppe/shoppe/pull/138))

* Updated Nifty Dialog ([#150](https://github.com/tryshoppe/shoppe/issues/150))

## v1.0.0

* Updates to the Gemfile to support Rails 4.1.

* Fixes issues with local jump errors in ActiveRecord blocks

* Renames the `public` scope on `Shoppe::ProductAttribute` to `publicly_accessible` and add deprecation warning for public.

## v0.0.20

* Add an admin-side order form for adding new orders and editing existing orders

* Adds `Shoppe::NavigationManager` which is used for managing sets of navigation within
  the Shoppe interface. This allows module developers to add their own when appropriate
  without needing to hack it into the view.

## v0.0.19

* Only check that a delivery service is suitable if one has actually been selected. Ensures that
  some orders can have no delivery service associated.

* Add country management to to the Shoppe UI.

* Split the order show page into some partials for easier updates later.

* If an order's total weight is 0, no delivery service is required.

* The seeds file is now less specific and the delivery services & tax rates contained within
  are not scoped to any countries so always apply.

* Catch `Shoppe::Errors::PaymentDeclined` errors when accepting and rejecting orders.

## v0.0.18

* Changes uglifier version

## v0.0.17

* Adds `number_to_currency` view helper which will use the correct currency as defined in the
  Shoppe settings.

* Adds `number_to_weight` which accpets a number of kilogramts and returns the number with the
  appropriate 'kg' suffix.
  
* Tax rates can choose whether to work with the delivery or billing address on the order

* Order details can be editted through the Shoppe UI

* Orders now have multiple payments associated with them which can be refunded as appropriate
  and module can hook into this as appropriate.

* `Shoppe::Order` and `Shoppe::Payment` models now have `exported` booleans in their schema
  which module can use to record when an object has been exported to an external system. 
  Shoppe does not enforce these and they are data-only attributes. 

* `Shoppe::Order` now has a `invoice_number` attribute which can be used by external systems
  to store the invoice number along with the order if one is created. This is displayed with the
  order details in the Shoppe UI.

## v0.0.16

* Adds despatch notes to orders

* Adds a default to product variants

* **Breaking change:** `Shoppe::Order#address` has been split into `Shoppe::Order#billing_address`
  and `Shoppe::Order#delivery_address`.

* **Breaking change:** all migrations have been collapsed. You will need to reset your database
  when upgrading to this version.
  
* **Breaking change:** settings are now all stored in the database and set up using the 
  Settings page within the Shoppe interface. There is no need for a `shoppe.yml` config
  file. If you have settings in such a file, they should be transferred to your database
  version on upgrade.

## v0.0.15 - The break everything release

* **Breaking change:** The `Shoppe::OrderItem` model no longer responds to `product` as part 
  of a change to allow items other than products to be ordered. Order items will now respond
  to `ordered_item` which is a polymorphic association to any model which implements the 
  `Shoppe::OrderableItem` protocol (see /lib/shoppe/orderable_item.rb). Base applications
  which work with this will need to be updated to use this new association name. Also, the
  `Shoppe::OrderItem.add_product` has been renamed to `Shoppe::OrderItem.add_item`.

* **Breaking change:** `Shoppe::Product#title` has been renamed to `Shoppe::Product#name`
  as title was a stupid name for a product. Base application will need to use `name` to 
  display the name of a product.
  
* **Breaking change:** `Shoppe::StockLevelAdjustment` is now polymorphic rather than only
  beloning to a product. `StockLevelAdjustment#product` has been replaced with 
  `StockLevelAdjustment#item`. This shouldn't require any adjustments to base applications
  unless they interact with the stock level adjustments model directly.
  
* Moves stock level adjustments into their own polymorphic accessible controller.

* Stock level adjustments are now managable from within a dialog (as well as without)

* Add's product variants which products to have sub-products which can be purchased as
  normal products.

* When accessing the name of an orderable item, you should use `full_name` rather than just
  `name`.
  
* Adds a demo mode to allow for auto logins and no user editting

## v0.0.14

* Fixes serious styling issue with the user form.

## v0.0.13

* Orders have notes which can be viewed & editted through the Shoppe UI.
* Adjustments to the design in the Shoppe UI.

## v0.0.12

* Don't persist order item pricing until the order is confirmed. While an order is being built
  all prices will be calculated live from the parent product and these values will be persisted
  (in case of any future changes to the product) at the point of confirmation. This makes way for
  changes to the tax rates based on order itself to be introduced.

## v0.0.11

* All countries are now stored in the database which will allow for delivery & tax rate decisions to
  be made as appropriate. There is now no need to use things like `country_select` in applications.
  Any existing order which has a country will have this data lost. A rake task method is provide to
  allow a default set of countries to be imported (`rake shoppe:import_countries`). There is
  currently no way to manage countries from the Shoppe interface.

* Items with prices are now assigned to a `Shoppe::TaxRate` object rather than specifying a
  percentage on each item manually. This allows rates to be changed globally and allows us to change
  how tax should be charged based
  on other factors (country?).

## v0.0.10

* Improved stock control so that a journal is kept of all stock movement in and out of the system.
  There is no need to make any changes to your application however all existing stock levels will be
  removed when upgrading to this version.
