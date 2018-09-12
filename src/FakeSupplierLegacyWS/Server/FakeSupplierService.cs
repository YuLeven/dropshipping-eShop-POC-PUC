using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server
{
  public class FakeSupplierService : IFakeService
  {

    public string SellItem(SellItemInput input)
    {
      return "Aknowledged";
    }
  }
}
