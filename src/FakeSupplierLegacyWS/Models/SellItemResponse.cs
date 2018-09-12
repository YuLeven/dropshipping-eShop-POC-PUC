using System;
using System.Collections.Generic;

namespace Models
{
  public class SellItemResponse
  {
    public string ProductName { get; set; }
    public int DeliveryETAInDays { get; set; }
    public float Price { get; set; }
    public DateTime PurchaseDate { get; set; }
  }
}
