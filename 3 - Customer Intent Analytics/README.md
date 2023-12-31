# Customer Intent Analytics

In the world of online shopping, the combination of products added to a customer's shopping basket can provide valuable insights. These insights can help businesses understand customer behavior, identify cross-selling opportunities and optimise marketing strategies. This is where basket analysis and the Apriori algorithm come in.


## Market Basket Analysis

Market basket analysis is a data mining technique used to improve sales through a deeper understanding of customer buying patterns. This technique involves examining large data sets, including purchase history, to uncover product groupings and identify items that are likely to be purchased together.

![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/75e796df-58b8-423a-b80b-187c02116277)

## Apriori Algorithm

The Apriori algorithm is a commonly used data mining algorithm for basket analysis. This algorithm establishes rules by identifying common combinations of items in the data set. These rules indicate the likelihood that customers will buy other items after purchasing a particular product.

For example, when a customer buys a smartphone, the Apriori algorithm can estimate the likelihood of that customer buying accessories such as a phone case, screen protector, or portable charger.

When performing basket analysis and using the Apriori algorithm, three essential concepts come into play: Support, Confidence, and Lift:

  * Support: shows how frequently a product combination appears in overall shopping baskets.
  
  * Confidence: is the measure of certainty or trustworthiness associated with each pattern. 
  For example, if a customer has bought a smartphone, what is the likelihood of them also purchasing a phone case?
  
 *  Lift: explains the change in probability of Y over (presence of X) and (absence of X) 
     
     Lift = 1 implies X makes no impact on Y
     
     Lift > 1 implies that the relationship between X and Y is more significant

  By using market basket analysis in conjunction with the Apriori algorithm, organizations can gain deeper insights into customer behavior and fine-tune marketing approaches. For example, an online retail platform can increase cross-selling opportunities by identifying products that are suitable for customer recommendations. In addition, these methods are proving valuable in developing efficient strategies for managing inventory and strategically placing products.
