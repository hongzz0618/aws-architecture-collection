#!/usr/bin/env python3
import argparse
import pickle
import numpy as np
import tarfile
import os
import boto3
import json

def create_simple_model():
    """Create a simple model without scikit-learn dependencies"""
    print("Creating simple ML model...")
    
    # Create a simple linear regression model manually
    class SimpleModel:
        def __init__(self):
            self.coef_ = np.array([0.5, -0.3, 0.8, 0.1])  # Mock coefficients
            self.intercept_ = 0.2
            
        def predict(self, X):
            return np.dot(X, self.coef_) + self.intercept_
    
    model = SimpleModel()
    print("Simple model created successfully")
    return model

def create_dummy_model():
    """Create an even simpler dummy model"""
    print("Creating dummy model...")
    
    class DummyModel:
        def __init__(self):
            self.version = "1.0"
            self.model_type = "dummy"
            
        def predict(self, X):
            # Return fixed predictions for iris-like data
            if len(X) == 0:
                return []
            return [0] * len(X)  # Always predict class 0
    
    model = DummyModel()
    print("Dummy model created successfully")
    return model

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bucket", required=True, help="S3 bucket name")
    parser.add_argument("--region", default="us-east-1", help="AWS region")
    args = parser.parse_args()
    
    try:
        # Try to create a simple model first
        model = create_simple_model()
        
        # Save model as pickle
        with open("model.pkl", "wb") as f:
            pickle.dump(model, f)
        
        # Create tar.gz for SageMaker
        with tarfile.open("model.tar.gz", "w:gz") as tar:
            tar.add("model.pkl", arcname="model.pkl")
        
        # Clean up
        os.remove("model.pkl")
        
        print("Model artifact created successfully")
        
        # Upload to S3
        s3 = boto3.client('s3', region_name=args.region)
        s3.upload_file("model.tar.gz", args.bucket, "model.tar.gz")
        print(f"✅ Model uploaded to: s3://{args.bucket}/model.tar.gz")
        
    except Exception as e:
        print(f"Error creating model: {e}")
        print("Creating fallback dummy model...")
        
        # Fallback: create a simple JSON-based model
        dummy_model = {
            "model_type": "dummy",
            "version": "1.0",
            "coefficients": [0.1, 0.2, 0.3, 0.4],
            "intercept": 0.5
        }
        
        # Save as JSON
        with open("model.json", "w") as f:
            json.dump(dummy_model, f)
        
        # Create tar.gz
        with tarfile.open("model.tar.gz", "w:gz") as tar:
            tar.add("model.json", arcname="model.json")
        
        # Clean up
        os.remove("model.json")
        
        # Upload to S3
        s3 = boto3.client('s3', region_name=args.region)
        s3.upload_file("model.tar.gz", args.bucket, "model.tar.gz")
        print(f"✅ Fallback model uploaded to: s3://{args.bucket}/model.tar.gz")

if __name__ == "__main__":
    main()