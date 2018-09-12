using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

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

  [DataContract]
  public class DeliveryAddress
  {
    [DataMember]
    public string Street { get; set; }

    [DataMember]
    public int ResidenceNumber { get; set; }
  }
}
