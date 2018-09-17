using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using Models;

namespace Models
{
  [DataContract]
  public class SellItemInput
  {
    [DataMember]
    public string ProductCode { get; set; }

    [DataMember]
    public int Quantity { get; set; }

    [DataMember]
    public DeliveryAddress DeliveryAddress { get; set; }
  }
}
