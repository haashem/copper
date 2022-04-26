# Copper App

App is fully tested with Unit, Integration, and Acceptance tests.

Test Coverages:

![Screen Shot 2022-04-26 at 10.12.22 PM.png](images/Screen_Shot_2022-04-26_at_10.12.22_PM.png)

![Screen Shot 2022-04-26 at 10.55.00 PM.png](images/Screen_Shot_2022-04-26_at_10.55.00_PM.png)

![Screen Shot 2022-04-26 at 10.12.46 PM.png](images/Screen_Shot_2022-04-26_at_10.12.46_PM.png)

### Orders.framework

Contains, different implementations of `OrderLoading` feature: `RemoteOrderLoader` and `LocalOrdersLoader`

### OrdersiOS.framework

iOS specific implementation of orders loader feature which uses UIKit to display orders. Focused on only displaying Orders, source of data doesn’t matter. we could easily verify UI with snapshot tests, without even running the app!

### Copper.app

This is the main module and composition root of the app, which composes iOS specific UI implementation with Remote and Local loaders to cover business requirements with support of Acceptance tests.  because from early stage we followed **SOLID** principles we can easily change behavior of the app without changing existing code, just by the we we compose loaders.

## High level dependency diagram

![Screen Shot 2022-04-26 at 9.54.43 PM.png](images/Screen_Shot_2022-04-26_at_9.54.43_PM.png)

##
