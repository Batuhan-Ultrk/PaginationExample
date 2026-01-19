# PaginationExample

# FolderPagination

SwiftUI, Swift Concurrency (`async / await`) ve MVVM mimarisi kullanılarak geliştirilmiş **sağlam, generic ve yeniden kullanılabilir bir pagination altyapısı**.

Bu proje, sayfalı veri yükleme ihtiyacı olan tüm ekranlarda **kod tekrarını ortadan kaldırmayı** ve **güvenli infinite scroll** sağlamayı amaçlar.

---

## ✨ Özellikler

- ✅ Generic pagination altyapısı (`loadPagedItems`)
- ✅ Swift Concurrency uyumu (`async / await`)
- ✅ MVVM mimarisi ile uyumlu
- ✅ KeyPath tabanlı state yönetimi
- ✅ Güvenli infinite scroll yapısı
- ✅ Mock servis desteği (backend gerektirmez) örnek kullanım
- ✅ Merkezi loading ve error yönetimi

---

## 🧠 Mimari Genel Bakış

- **Pagination mantığı** `BaseViewViewModel` içinde bulunur
- **Pagination state** tamamen `PaginationState` ile yönetilir
- **UI katmanı** ViewModel’den ayrıdır ve tekrar kullanılabilir

---

## 📦 Temel Bileşenler

### PaginationState

Pagination ile ilgili tüm bilgileri tek bir yapıda tutar.

```swift
struct PaginationState {
    var page: Int
    var per: Int
    var total: Int
    var pageCount: Int
}
```


PageResponse
Pagination altyapısının beklediği standart response yapısı.
```swift
struct PageResponse<T: ResponseComposition>: ResponseComposition {
    let items: [T]
    let metadata: PageMetadata
}
```

BaseViewViewModel
Pagination, loading ve error yönetiminin merkezi noktasıdır.

```swift
func loadPagedItems<Item: ResponseComposition>(
    itemsKeyPath: ReferenceWritableKeyPath<D, [Item]>,
    paginationKeyPath: ReferenceWritableKeyPath<D, PaginationState>,
    loading type: LoadingType,
    fetch: @escaping (_ page: Int, _ per: Int) async throws -> PageResponse<Item>
) async
```
👉 Aynı fonksiyon farklı tüm liste ekranlarında kullanılabilir.

🔁 Pagination Akışı
Aynı anda birden fazla istek engellenir
isLoading = true yapılır
Async fetch çağrısı gerçekleştirilir
İlk sayfada liste replace edilir
Sonraki sayfalarda listeye append yapılır
Pagination metadata güncellenir
Loading state sıfırlanır

🧪 Mock Servis Yapısı
Projede backend olmadan çalışabilen mock pagination servisleri bulunur.
MockFolderService.fetchFolders(page: per:)
Avantajları:
Offline çalışır
Gerçek backend davranışını simüle eder
UI ve pagination testleri için idealdir

🧱 Güvenli Infinite Scroll
PaginationView
Binding kaynaklı crash’leri önleyen güvenli bir liste bileşeni.
```swift
PaginationView(
    items: $viewState.folderList,
    loadMore: {
        await viewModel.loadFolders()
    }
) { item, safeAction in
    FolderRow(
        folder: item,
        onTap: safeAction { folder in
            print(folder)
        }
    )
}
```
SafeAction Neden Var?
 - Liste güncellenirken:
 - item silinmesi
 - index kayması
 - geçersiz binding
gibi durumlarda crash oluşmasını engeller.

🚀 ViewModel Kullanım Örneği
```swift
@MainActor
func loadFolders() async {
    await loadPagedItems(
        itemsKeyPath: \.folderList,
        paginationKeyPath: \.folderPagination,
        loading: .local,
        fetch: { page, per in
            try await MockFolderService.fetchFolders(
                page: page,
                per: per
            )
        }
    )
}
```
ViewModel içinde pagination logic yoktur, sadece niyet vardır.

🧠 Bu Yapının Avantajları
  ❌ Ekran bazlı pagination kodu yok
  
  ❌ Kopyala–yapıştır yok
  
  ❌ Unsafe binding yok
  
  ✅ Tamamen reusable
  
  ✅ Test edilebilir
  
  ✅ Ölçeklenebilir

## 📖 İlgili Makale
Bu mimarinin detaylarını ve arkasındaki mantığı anlattığım Medium yazısına buradan ulaşabilirsiniz: 
[Swift Concurrency ile Generic ve Güvenli Pagination Altyapısı](https://medium.com/@batuhanuluturk1463/swift-concurrency-ile-generic-ve-güvenli-pagination-altyapısı-0846e3811ad7)

