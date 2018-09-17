using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Models
{
  [DataContract]
  public class DeliveryAddress
  {
    [DataMember]
    public string Address { get; set; }

    [DataMember]
    public string City { get; set; }

    [DataMember]
    public string State { get; set; }

    [DataMember]
    public string ZipCode { get; set; }

    [DataMember]
    public int ResidenceNumber { get; set; }
  }
}