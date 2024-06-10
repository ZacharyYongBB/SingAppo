//
//  ProductCellView.swift
//  SingAppo
//
//  Created by Zachary on 10/6/24.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ImageLoaderView(urlString: product.thumbnail ?? "", resizeMode: .fill)
                .frame(width: 75, height: 75)
                .cornerRadius(10)
                .shadow(radius: 30)
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title ?? "No title")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Price: " + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "Uncategorized"))
                Text("Brand: " + (product.brand ?? "No Brand"))
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "123", description: "123", price: 1.2, discountPercentage: 1.2, rating: 1.23, stock: 1, brand: "123", category: "123", thumbnail: "123", images: []))
}
