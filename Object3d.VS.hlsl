struct TransformationMatrix {
	float32_t4x4 WVP;
};

ConstantBuffer<TransformationMatrix> gTransformationMatrix : register(b0);
struct VertexShaderOutput {
	float32_t4 position : SV_POSITION;
};
struct VertexShaderInput {
	float32_t4 position : POSITION0;
};
VertexShaderOutput main(VertexShaderInput input) {
	VertexShaderOutput output;
	output.position = mul(input.position, gTransformationMatrix.WVP);
	return output;
}

////2_04
//
//CoInitializeEx(0, COINIT_MULTITHREADED);
//
//CoUninitialize();
//
//DirectX::ScratchImage LoadTexture(const std::string& filePath)
//{
//	//テクスチャファイルを読んでプログラムを扱えるようにする
//	DirectX::ScratchImage image{};
//	std::wstring filePathW = ConvertString(filePath);
//	HRESULT hr = DirectX::LoadFromWICFile(filePathW.c_str(), DirectX::WIC_FLAGS_FORCE_SRGB, nullptr, image);
//	assert(SUCCEEDED(hr));
//
//	//ミニマップの作成
//	DirectX::ScratchImage mipImage{};
//	hr = DirectX::GenerateMipMaps(image.GetImage(), image.GetImageCount(), image.GetMetadata(), DirectX::TEX_FILTER_SRGB, 0, mipImages);
//	assert(SUCCEEDED(hr));
//
//	//ミップマップ付きのデータを返す
//	return mipImages;
//}
//
//ID3D12Resource* CreateTextureResource(ID3D12Device* device, const DirectX::TexMetadata& metadata)
//{
//	//1.metadataを基にResorceの設定
//	//2.利用するHeapの設定
//	//3.Resourceを生成する
//}
//
////metadataを基にResourceの設定
//D3D12_RESOURCE_DESC resourceDesc{};
//resourceDesc.Width = UINT(metadata.width);
//resourceDesc.Height = UINT(metadata.height);
//resourceDesc.MipLevels = UINT16(metadata.mipLevels);
//resourceDesc.DepthOrArraySize = UINT16(matadata.arraySize);
//resourceDesc.Format = metadata.format;
//resourceDesc.SampleDesc.Count = 1;
//resourceDesc.Dimension = D3D12_RESOURCE_DIMENSION(metadata.dimension);
//
////利用するHeapの設定。非常に特殊な運用。02_04exで一般的なケースがある
//D3D12_HEAP_PROPERTIES heapProperties{};
//heapProperties.Type = D3D12_HEAP_TYPE_CUSTOM;
//heapProperties.CPUPageProperty = D3D12_CPU_PAGE_PROPERTY_WRITE_BACK;
//heapProperties.MemoryPoolPreference = D3D12_MEMORY_POOL_L0;
//
////Resorceの生成
//ID3D12Resource* resource = nullptr;
//HRESULT hr = device->CreateCommittedResource(
//	&heapProperties,
//	D3D12_HEAP_FLAG_NONE,
//	&resourceDesc,
//	D3D12_RESOURCE_STATE_GENERIC_READ,
//	nullptr,
//	IID_PPV_ARGS(&resource));
//assert(SUCCEEDED(hr));
//return resource;
//
//void UploadTextureData(ID3D12Resource* texture, const DirectX::ScratchImage& mipImages)
//{
//	//Meta情報を取得
//	const DirectX::TexMetadata& metadata = mipImages.GetMetadata();
//	//全MipMapについて
//	for (size_t mipLevel = 0; mipLevel < metadata.mipLevels; ++mipLevel) {
//		//MipMapLevelを指定して各Imageを取得
//		const DirectX::Image* img = mipImages.GetImage(mipLevel, 0, 0);
//		//Textureに転送
//		HRESULT hr = texture->WriteToSubresource(
//			UINT(mipLevel),
//			nullptr,
//			img->pixels,
//			UINT(img->rowPitch),
//			UINT(img->slicePitch)
//		);
//		assert(SUCCEEDED(hr));
//	}
//}
//
////Textureを読んで転送する
//DirectX::ScratchImage mipImages = LoadTexture("resources/uvChecker.png");
//const DirectX::TexMetadata& metadata = mipImages.GetMetadata();
//ID3D12Resource* textureResource = CreateTextureResource(device, metadata);
//UpLoadTextureData(textureResource, mipImages);
//
////mataDataを基にSRVの設定
//D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc{};
//srvDesc.Format = metadata.format;
//srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
//srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
//srvDesc.Texture2D.MipLevels = UINT(metadata.mipLevels);
//
////SRVを生成するDescriptorHeapの場所を決める
//D3D12_CPU_DESCRIPTOR_HANDLE textureSrvHandleCPU = srvDescriptorHeap->GetCPUDescriptorHandleForHeapStart();
//D3D12_CPU_DESCRIPTOR_HANDLE textureSrvHandleGPU = srvDescriptorHeap->GetGPUDescriptorHandleForHeapStart();
//
////先頭はImGuiが使っているのでその次を使う
//textureSrvHandleCPU.ptr += device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
//textureSrvHandleGPU.ptr += device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
////SRVの生成
//device->CreateShaderResourceView(textureResource, &srvDesc, textureSrvHandleCPU);
//
//struct VertexData
//{
//	Vector4 position;
//	Vector2 texcoord;
//};
//
////頂点リソースにデータを書き込む
//VertexData* vertexData = nullptr;
////書き込むためのアドレスを取得
//vertexResource->Map(0, nullptr,
//	reinterpret_cast<void**>(&vertexData));
////左下
//vertexData[0].position = { -0.5f,-0.5f,0.0f,1.0f };
//vertexData[0].texcoord = { 0.0f,1.0f };
////上
//vertexData[1].position = { 0.0f,0.5f,0.0f,1.0f };
//vertexData[1].texcoord = { 0.5f,0.0f };
////右下
//vertexData[2].position = { 0.5f,-0.5f,0.0f,1.0f };
//vertexData[2].texcoord = { 1.0f,1.0f };
//
//D3D12_INPUT_ELEMENT_DESC inputElementDescs[2] = {};
//inputElementDescs[0].SemanticName = "POSITION";
//inputElementDescs[0].SemanticIndex = 0;
//inputElementDescs[0].Format = DXGI_FORMAT_R32G32B32A32_FLOAT;
//inputElementDescs[0].AlignedByteOffset = D3D12_APPEND_ALIGNED_ELEMENT;
//inputElementDescs[1].SemanticName = "TEXCOORD";
//inputElementDescs[1].SemanticIndex = 0;
//inputElementDescs[1].Format = DXGI_FORMAT_R32G32_FLOAT;
//inputElementDescs[1].D3D12_APPEND_ALIGNED_ELEMENT;
//
//D3D12_INPUT_LAYOUT_DESC inputLayoutDesc{};
//inputLayoutDesc.pInputElementDescs = inputElementDescs;
//inputLayoutDesc.NumElements = _countof(inputElementDescs);
//
//struct VertexShaderOutput {
//	flaot32_t4 position : SV_POSITION;
//	flaot32_t2 texcoord : TEXCOORD0;
//};
//
//#include "object3d.hlsli"
//
//output.texcoord = input.texcoord;
//
//Texture2D<flaot32_t4> gTexture : register(t0);
//SamplerState gSampler : register(s0);
//
//float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);
//
//output.color = gMaterial.color * textureColor;
//
//D3D12_ROOT_PARAMETER rootParameters[3] = {};
//
//D3D12_DESCRIPTOR_RANGE descriptorRange[1] = {};
//descriptorRange[0].BaseShaderRegister = 0;
//descriptorRange[0].NumDescriptors = 1;
//descriptorRange[0].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
//descriptorRange[0].OffsetInDescriptorsFromTableStart = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND;
//
//rootParameters[2].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
//rootParameters[2].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
//rootParameters[2].DescriptorTable.pDescriptorRanges = descriptorRange;
//rootParameters[2].DescriptorTable.NumDescriptorRanges = _countof(descriptorRange);
//
//descriptorRange[0]
//
//BaseShaderRegister = 3;
//NumDescriptors = 2;
//RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
//
//descriptorRange[1]
//
//BaseShaderRegister = 0;
//NumDescriptors = 3;
//RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_CBV;
//
//ConstantBuffer<> gMaterial0 : register(b0);
//ConstantBuffer<> gMaterial1 : register(b1);
//ConstantBuffer<> gMaterial2 : register(b2);
//Texture2D<> gTexture0 : register(t3);
//Texture2D<> gTexture1 : register(t4);
//
//D3D12_STATIC_SAMPLER_DESC staticSamplers[1] = {};
//staticSamplers[0].Filter = D3D12_FILTER_MIN_MAG_MIP_LINEAR;
//staticSamplers[0].AddressU = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
//staticSamplers[0].AddressV = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
//staticSamplers[0].AddressW = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
//staticSamplers[0].ComparisonFunc = D3D12_COMPARISON_FUNC_NEVER;
//staticSamplers[0].MaxLOD = D3D12_FLOAT32_MAX;
//staticSamplers[0].ShaderRegister = 0;
//staticSamplers[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
//descriptionRootSignature.pStaticSamplers = staticSamplers;
//descriptionRootSignature.NumStaticSamplers = _countof(staticSamplers);
//
//float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);
//
//output.color = gMaterial.color * textureColor;
//
////SRVのDescriptorTableの先頭を設定。2はrootParameter[2]である。
//commandList->SetGraphicsRootDescriptorTable(2, textureSrvHandleGPU);
//
////2_4"
//
//D3D12_HEAP_PROPERTILES heapPropertils{};
//heapProperties.Type = D3D12_HEAP_TYPE_CUSTOM;
//heapProperties.CPUPageProperty = D3D12_CPU_PAGE_PROPERTY_WRITE_BACK;
//heapProperties.MemoryPoolPreference = D3D12_MEMORY_POOL_L0;
//
//#include "externals/DirectTex/d3dx12.h"
//
//#include <vector>
//
//D3D12_HEAP_PROPERTIES heapProperties{};
//heapProperties.Type = D3D12_HEAP_TYPE_DEFAULT;
//
//ID3D12Resource* resource = nullpter;
//HRESULT hr = device->CreateCommittedResource(
//	&heapProperties,
//	D3D12_HEAP_FLAG_NONE,
//	&resourceDesc,
//	D3D12_RESOURCE_STATE_COPY_DEST,
//	nullptr,
//	IID_PPV_ARGS(&resource));
//
//[[nodiscard]]
//ID3D12Resorce* UploadTextureData(ID3D12Resource* texture, const DirectX::ScratchImage& mipmages, ID3D12Device* device,
//	ID3D12GraphicsCommandList* commandList)
//{
//	std::vector<D3D12_SUBRESOURCE_DATA> subresources;
//	DirectX::PrepareUpload(device, mipImages.Getimages(), mipImages.GetMetadata(), subresorces);
//	uint64_t intermediateSize = GetRequiredIntermediateSize(texture, 0, UINT(subresources.size()));
//	ID3D12Resorce* intermediateResource = CreateBufferResource(device, intermediateSize);
//	UpdateSubresources(commandList, texture, intermediateResorce, 0, 0, UINT(subresource.size())), subresources.data());
//
//	D3D12_RESOURCE_BARRIER barrier{};
//	barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
//	barrier.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
//	barrier.Transition.pResource = texture;
//	barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
//	barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
//	barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_GENERIC_READ;
//	commandList->ResourceBarrier(1, &barrier);
//	return intermediateResource;
//}
//
//std::vector<D3D12_SUBRESOURCE_DATA> subresource;
//DirectX::PrepareUpload(device, mipImages.GetImages(), mipImages.GetImageCount(), mipImages.GetMetadata(), subresources);
//uint64_t intermediateSize = GetRequiredIntermediateSize(texture, 0, UINT(subresource.size()));
//ID3D12Resource* intermediateResource = CreateBufferResource(device, intermediateSize);
//
//UpdateSubresources(commandList, texture, intermediateResource, 0, 0, UINT(subresource.size()), subresources.data());
//
//D3D12_RESOURCE_BARRIER barrier{};
//barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
//barrier.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
//barrier.Transition.pResource = texture;
//barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
//barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DESC;
//barrier.Transition.StateAfetr = D3D12_RESOURCE_STATE_GENERIC_READ;
//commandList->ResourceBarrier(1, &barrier);
//return intermediateResource;
//
//ID3D12Resource* intermediateResource = UpLoadTextureData(textureResource, mipImages, device, commandList);

////2_05
//
//ID3D12Resource* vertexResource = CreateBufferResource(device, sizeof(VertexData) * 6);
//
//vertexBufferView.SizeInBytes = sizeof(VertexData) * 6;
//
////左2
//vertexData[3].position = { -0.5f,-0.5f,0.5f,1.0f };
//vertexData[3].texcoord = { 0.0f,1.0f };
//
////上2
//vertexData[4].position = { 0.0f,0.0f,0.0f,1.0f };
//vertexData[4].texcoord = { 0.5f,0.0f };
//
////右上2
//vertexData[5].position = { 0.5f,-0.5f,-0.5f,1.0f };
//vertexData[5],texcoord = { 1.0f,1.0f };
//
//commandList->DrawInstanced(6, 1, 0, 0);
//
//ID3D12Resource* CreateDepthStencilTextureResource(ID3D12Device* device, int32_t width, int32_t height)
//
//D3D12_RESOURCE_DESC resourceDesc {};
//resourceDesc.Width = width;
//resourceDesc.Height = height;
//resourceDesc.MipLevels = 1;
//resourceDesc.DepthOrArraySize = 1;
//resourceDesc.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
//resourceDesc.SampleDesc.Count = 1;
//resourceDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
//resourceDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;
//
//D3D12_HEAP_PROPERTIES heapProperties{};
//heapProperties.Type = D3D12_HEAP_TYPE_DEFAULT;
//
//D3D12_CLEAR_VALUE depthClearValue{};
//depthClearValue.DepthStencil.Depth = 1.0f;
//depthClearValue.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
//
//ID3D12Resource* resorce = nullptr;
//HRESULT hr = device->CreateCommittedResource(
//	&heapProperties,
//	D3D12_HEAP_FLAG_NONE,
//	&resourceDesc,
//	D3D12_RESOURCE_STATE_DEPTH_WRITE,
//	&depthClearValue,
//	IID_PPV_ARGS(&resource));
//assert(SUCCEEDED(hr));
//
//ID3D12Resource* depthStencilResource = CreateDepthStencilTextureResource(device, kClientWidth, kClientHeight);
//
//D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc{};
//dsvDesc.Format = DXGI_FORMAT_D24_UNORM_S8_UINT;
//dsvDesc.ViewDimension = D3D12_DSV_DIMENSIONTEXTURE2D;
//
//device->CreateDepthStencilView(depthStencilResource, &dsvDesc, dsvDescriptorHeap->GetCPUDescriptorHandleForHeapStart());
//
//D3D12_DEPTH_STENCIL_DESC depthStencilDesc{};
//
//depthStencilDesc.DepthEnable = true;
//
//depthStencilDesc.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
//
//depthStencilDesc.DepthFunc = D3D12_COMPARISON_FUNC_LESS_EQUAL;
//
//graphicsPipelineStateDesc.DepthStencilState = depthStencilDesc;
//graphicsPipelineStateDesc.DSVFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;
//
//bool DepthFunc(float currZ, float prevZ)
//{
//	return currZ <= prevZ;
//}
//
//if (DepthFunc(currZ, prevZ))
//{
//
//}
//else {
//
//}
//
//bool DepthFunc(float currZ, flaot prevZ)
//{
//	return currZ >= prevZ;
//}
//
//D3D12_CPU_DESCRIPTOR_HANDLE dsvHandle = dsvDescriptorHeap->GetCPUDescriptorHandleForHeapStart();
//commandList->OMSetRenderTargets(1, &rtvHandles[backBufferIndex], false, &dsvHandle);
//
//commandList->ClearDepthStencilView(dsvHandle, D3D12_CLEAR_FLAG_DEPTH, 1.0f, 0, 0, nullptr);

////3_0
//
//ID3D12Resource* vertexResourceSprite = CreateBufferResource(device, sizef(VertexData) * 6);
//
//D3D12_VERTEX_BUFFER_VIEW vertexBufferViewSprite{};
//
//vertexBufferViewSprite.BufferLocation = vertexResourceSprite->GetGPUVirtualAddress();
//
//vertexBufferViewSprite.SizeInBytes = sizeof(VertexData) * 6;
//
//vertexBufferViewSprite.StrideInBytes = sizeof(VertexData);
//
//
//VertexData* vertexDataSprite = nullptr;
//vertexResourceSprite->Map(0, nullptr, reinterpret_cast<void**>(&vertexDataSprite));
////一枚目の三角形
//vertexDataSprite[0].position = { 0.0f,360.0f,0.0f,1.0f };//左下
//vertexDataSprite[0].texcoord = { 0.0f,1.0f };
//vertexDataSprite[1].position = { 0.0f,0.0f,0.0f,1.0f };//左上
//vertexDataSprite[1].texcoord = { 0.0f,0.0f };
//vertexDataSprite[2].position = { 640.0f,360.0f,0.0f,1.0f };//右下
//vertexDataSprite[2].texcoord = { 1.0f,1.0f };
//
////二枚目の三角形
//vertexDataSprite[3].position = { 0.0f,0.0f,0.0f,1.0f };//左上
//vertexDataSprite[3].texcoord = { 0.0f,0.0f };
//vertexDataSprite[4].position = { 640.0f,0.0f,0.0f,1.0f };//右上
//vertexDataSprite[4].texcoord = { 1.0f,0.0f };
//vertexDataSprite[5].position = { 640.0f,360.0f,0.0f,1.0f };//右下
//vertexDataSprite[5].texcoord = { 1.0f,1.0f };
//
//ID3D12Resorce* transformationMatrixResourceSprite = CreateBufferResource(device, sizeof(Matrix4x4));
//
//Matrix4x4* transformationMatrixDataSprite = nullptr;
//
//transformationMatrixDataSprite = nullptr;
//
//transformationMatrixResourceSprite->Map(0, nullptr, reinterpret_cast<void**>(&transformationMatrixDataSprite));
//
//*transformationMatrixDataSprite = MakeIdentity4x4();
//
//Transform transformSprite{ {1.0f,1.0f,1.0f},{0.0f,0.0f,0.0f},{0.0f,0.0f,0.0f} };
//
//Matrix4x4 worldMatrixSprite = MakeAffineMatrix(transformSprite, scale, transformSprite.rotate, tarnsformSprite.translate);
//Matrix4x4 viewMatrixSprite = MakeIdentity4x4();
//Matrix4x4 projectionMatrixSprite = MakeOrthographicMatrix(0.0f, 0.0f, float(kClientWidth), float(kClienHeight), 0.0f, 100.0f);
//Matrix4x4 worldViewProjectionMatrixSprite = Multiply(worldMatrixSprite, Multiply(viewMatrixSprite, projectionMatirxSprite));
//*transformationMatrixDataSprite = worldViewProjectionMatrixSprite;
//
//commandList->IASetVertexBuffers(0, 1, &vertexBufferViewSprite);
//
//commandList->SetGraphicsRootConstantBufferView(1, transformationMatrixResourceSprite->GetGPUVirtualAddress());
//
//commandList->DrawInstanced(6, 1, 0, 0);


//4_0

//uint32_t startIndex = (latIndex * kSubdivision + lonIndex) * 6;
//
//u = float(lonIndex) / float(kSubdivision);
//v = 1.0f - float(latIndex) / float(kSubdivision);
//
//const float kLonEvery = pi * 2.0f / flaot(kSubdivision);
//
//const float kLatEvery = pi / float(kSubdivision);
//
//for (latIndex = 0; latIndex < kSubdivision; ++latIndex) {
//	float lat - pi / 2.0f + kLatEvery * latIndex;
//
//	for (lonIndex = 0; lonIndex < kSubdivision; ++lonIndex) {
//		uint32_t start = (latIndex * kSubdivision + lonIndex) * 6;
//		float lon = lonIndex * kLonEvery;
//
//		vertexData[start].position.x = cos(lat) * cos(lon);
//		vertexData[start].position.y = sin(lat);
//		vertexData[start].position.z = cos(lat) * sin(lon);
//		vertexData[start].position.w = 1.0f;
//		vertexData[start].position = ...;
//	}
//}
//
//commandList->DrawInstanced(球の頂点数,1,0,0);

//4_1

//D3D12_CPU_DESCRIPTOR_HANDLE GetCPUDescriptorHandle(ID3D12DescriptorHeap* descriptorHeap, uint32_t desriptorSize, uint32_t index)
//{
//	D3D12_CPU_DESCRIPTOR_HANDLE handleCPU = descriptorHeap->GetCPUDescriptorHandleForHeapStart();
//	handleCPU.ptr += (desriptorSize * index);
//	return handleCPU;
//}
//
//D3D12_GPU_DESCRIPTOR_HANDLE GetGPUDescriptorHandle(ID3D12DescriptorHeap* descriptorHeap, uint32_t desriptorSize, uint32_t index)
//{
//	D3D12_GPU_DESCRIPTOR_HANDLE handleGPU = descriptorHeap->GetGPUDescriptorHandleForHeapStart();
//	handleGPU.ptr += (desriptorSize * index);
//	return handleGPU;
//}
//
//const uint32_t desriptorSizeSRV = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
//const uint32_t desriptorSizeRTV = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
//const uint32_t desriptorSizeDSV = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
//
//GetCPUDescriptorHandle(rtvDescriptorHeap, desriptorSizeRTV, 0);
//
//DirectX::ScratchImage mipImage2 = LoadTexture("resources/monsterBall.png");
//const DirectX::TexMetadata& metadata2 = mipImage2.GetMetadata();
//ID3D12Resource* textureResource2 = CreateResource(device, metadata2);
//UploadTextureData(textureResource2, mipImages2);
//
//D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc2{};
//srvDesc2.Format = metadata2.format;
//srvDesc2.Shader4ComponentMapping = D3D12_DED12_DEFAULT_SHADER_4COMPONENT_MAPPING;
//srvDesc2.Viewimension = D3D12_SRV_DIMENSION_TEXTURE2D;
//srvDesc2.Texture2D.MipLevels = UINT(metadata2.mipLevels);
//
//D3D12_CPU_DESCRIPTOR_HANDLE textureSrvHandleCPU2 = GetCPUDescriptorHandle(srvDescriptorHeap, desriptorSizeSRV, 2);
//D3D12_GPU_DESCRIPTOR_HANDLE textureSrvHandleGPU2 = GetCGUDescriptorHandle(srvDescriptorHeap, desriptorSizeSRV, 2);
//
//device->CreateShaderResourceView(textureResource2, &srvDesc2, textureSrvHandleCPU2);
//
//commandList->SetGraphicsRootDescriptorTable(2, textureSrvHandleGPU);
//
//commandList->SetGraphicsRootDescriptorTable(2, textureSrvHandleGPU2);
//
//bool useMonsterBall = true;
//
//ImGui::Checkbox("useMonsterBall", &useMosterBall);
//
//commandList->SetGraphicsRootDescriptorTable(2, useMonsterBall ? textureSrvHandleGPU2 : textureSrvhHandleGPU);
//
//commandList->SetGraphicsRootDescriptorTable(2, textureSrvHandleGPU);








