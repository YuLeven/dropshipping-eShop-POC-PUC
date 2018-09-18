using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Server
{
  public class FakeSupplierService : IFakeService
  {

    private readonly ILogger _logger;

    public FakeSupplierService(ILogger<FakeSupplierService> logger) => _logger = logger;

    public SellItemResponse SellItem(SellItemInput input)
    {

      _logger.LogInformation("Received product sale request:");
      _logger.LogInformation(JsonConvert.SerializeObject(input));

      return new SellItemResponse
      {
        RequestStatus = "Accepted",
        ProductName = $"Some Product (x{input.Quantity})",
        DeliveryETAInDays = 12,
        Price = 10.99f * input.Quantity,
        PurchaseDate = DateTime.Now,
        DeliveryAddress = input.DeliveryAddress
      };
    }
  }
}
