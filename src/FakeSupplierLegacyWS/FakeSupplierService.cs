using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server
{
  public class FakeSupplierService : IFakeService
  {

    public SellItemResponse SellItem(SellItemInput input)
    {
      return new SellItemResponse
      {
        ProductName = "Some Product",
        DeliveryETAInDays = 12,
        Price = 10.99f,
        PurchaseDate = DateTime.Now
      };
    }
  }
}
