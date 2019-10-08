class ALevelGenerator : AActor 
{

    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxCollision;

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionEnabled = false;

    UFUNCTION(BlueprintOverride)
    void ConstructionScript() 
    {
        MeshComp.SetWorldScale3D(FVector(30, 8, 1));
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Print("New Level Generated", 5);
    }
}