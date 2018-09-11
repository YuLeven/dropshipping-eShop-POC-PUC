using System.ServiceModel;
using System.Threading.Tasks;

namespace Models
{
  [ServiceContract]
  public interface IFakeService
  {
    [OperationContract]
    SellItemResponse SellItem(SellItemInput input);
  }
}
